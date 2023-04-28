# frozen_string_literal: true

module Entities
  class IndexQuery
    include ApplicationInteractor

    contract do
      params do
        required(:entity_ids).filled { array? { each { string? } } }
      end
    end

    def call
      body = Jbuilder.new do |json|
        json.query do
          json.bool do
            json.filter do
              json.array! ['fuck!'] do
                json.terms do
                  json.id context.entity_ids
                end
              end
            end
          end
        end
      end

      context.object = {}.tap do |h|
        h[:body] = body.attributes!.deep_symbolize_keys
        h[:index] = Elastic::IndexName.pick('entities').scoped
        h[:size] = 10_000
        h[:from] = 0
        # h[:_source] = context._source
      end
    end
  end
end
