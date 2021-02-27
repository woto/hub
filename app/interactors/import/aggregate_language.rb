# frozen_string_literal: true

module Import
  class AggregateLanguage
    include ApplicationInteractor

    class Contract < Dry::Validation::Contract
      params do
        config.validate_keys = true
        required(:feed).value(type?: Feed)
      end
    end

    before do
      result = Contract.new.call(context.to_h)
      raise result.inspect if result.failure?
    end

    def call
      query = AggregateLanguageQuery.call(feed: context.feed).object
      result = client.search(query)
      language = result['aggregations']['group']['buckets'].dig(0, 'key')
      context.feed.update!(operation: 'detect language', language: language)
    end
  end
end
