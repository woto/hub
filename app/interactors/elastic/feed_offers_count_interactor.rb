# frozen_string_literal: true

module Elastic
  class FeedOffersCountInteractor
    include ApplicationInteractor

    contract do
      params do
        config.validate_keys = true
        required(:feed).maybe(type?: Feed)
      end
    end

    def call
      query = FeedOffersCountQuery.call(feed: context.feed).object
      context.object = GlobalHelper.elastic_client.count(query)['count']
    end
  end
end
