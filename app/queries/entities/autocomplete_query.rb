# frozen_string_literal: true

module Entities
  class AutocompleteQuery
    include ApplicationInteractor

    contract do
      params do
        optional(:q)
        optional(:entity_ids)
        optional(:entity_title)
        optional(:from)
        optional(:to)
      end
    end

    def call
      body = Jbuilder.new do |json|
        json.query do
          json.bool do

            if context.entity_ids
              json.filter do
                json.terms do
                  json.set! 'id', context.entity_ids
                end
              end
            end

            if context.q.present?
              json.must do
                json.multi_match do
                  json.query context.q
                  json.type 'bool_prefix'
                  json.fields do
                    json.array! %w[
                      title.autocomplete
                      title.autocomplete._2gram
                      title.autocomplete._3gram
                    ]
                  end
                end
              end
            end
          end
        end
      end

      context.object = {}.tap do |h|
        h[:body] = body.attributes!.deep_symbolize_keys
        h[:index] = Elastic::IndexName.pick('entities').scoped
        h[:size] = context.size
        h[:from] = context.from
        h[:_source] = context._source
      end
    end
  end
end
