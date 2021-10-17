# frozen_string_literal: true

# NOTE: not tested
module Production
  class ShrinkedFeed
    include ApplicationInteractor

    contract do
      params do
        config.validate_keys = true
        required(:feed).value(type?: Feed)
        required(:size).filled(:integer)
      end
    end

    def call
      query = Production::ShrinkedFeedQuery.call(feed: context.feed, size: 2).object
      context.object = GlobalHelper.elastic_client.search(query)
    end
  end
end
