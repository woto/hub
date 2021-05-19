# frozen_string_literal: true

module Import
  class AggregateLanguage
    include ApplicationInteractor

    contract do
      params do
        config.validate_keys = true
        required(:feed).maybe(type?: Feed)
      end
    end

    def call
      return unless context.feed

      query = AggregateLanguageQuery.call(feed: context.feed).object
      result = GlobalHelper.elastic_client.search(query)
      language = result['aggregations'][GlobalHelper::GROUP_NAME.to_s]['buckets'].dig(0, 'key')
      context.feed.update!(operation: 'detect language', language: language)
    end
  end
end
