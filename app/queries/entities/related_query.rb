# frozen_string_literal: true

module Entities
  class RelatedQuery
    include ApplicationInteractor

    contract do
      params do
        optional(:q)
        optional(:entity_ids)
        optional(:entity_title)
      end
    end

    def call
      body = Jbuilder.new do |json|
        json.query do
          json.bool do
            json.filter do
              if context.q.present?
                json.array! ['fuck'] do
                  json.query_string do
                    json.query context.q
                  end
                end
              end

              json.array! ['fuck'] do
                if context.entity_ids.present?
                  json.nested do
                    json.path "entities"
                    json.query do
                      json.array! ['fuck!'] do
                        json.terms do
                          json.set! "entities.entity_id", context.entity_ids
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end

        json.aggs do
          json.group do
            json.nested do
              json.path 'entities'
            end
            json.aggs do
              json.group do
                json.terms do
                  json.field 'entities.entity_id'
                  json.size context.size
                end
              end
            end
          end
        end
      end

      context.object = {}.tap do |h|
        h[:body] = body.attributes!.deep_symbolize_keys
        h[:index] = Elastic::IndexName.pick('mentions').scoped
        h[:size] = context.size
        h[:from] = context.from
        h[:_source] = context._source
      end
    end
  end
end
