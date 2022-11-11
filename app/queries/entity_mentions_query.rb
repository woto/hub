# frozen_string_literal: true

class EntityMentionsQuery
  include ApplicationInteractor

  contract do
    params do
      required(:q)
      optional(:entity_ids).maybe { array? { each { integer? } } }
      optional(:sort)
      optional(:order)
    end
  end

  def call
    # debugger
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
      json.sort do
        json.array! ['fuck'] do
          json.set! context.sort do
            json.nested do
              json.path "entities"
            end
            json.order context.order
          end
        end

        json.array! ['fuck'] do
          json.set! 'created_at' do
            json.order 'desc'
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
