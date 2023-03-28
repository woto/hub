# frozen_string_literal: true

module Offers
  class RandomQuery
    include ApplicationInteractor

    def call
      body = Jbuilder.new do |json|
        json.query do
          json.function_score do
            json.functions do
              json.array! ['fuck'] do
                json.random_score do
                  json.seed (Time.now.to_f * 100_000_000).to_i
                end
              end
            end
          end
        end
      end

      context.object = {}.tap do |h|
        h[:body] = body.attributes!.deep_symbolize_keys
        h[:index] = Elastic::IndexName.pick('offers').scoped
        h[:size] = 1
        h[:from] = 0
        h[:_source] = context._source
      end
    end
  end
end
