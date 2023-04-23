# frozen_string_literal: true

module Import
  class AggregateLanguageInteractor
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
      languages = result['aggregations'][GlobalHelper::GROUP_NAME.to_s]['buckets']
                  .map { |obj| [obj['key'], obj['doc_count']] }.to_h
      context.feed.update!(operation: 'detect language', languages: languages)
    end
  end
end
