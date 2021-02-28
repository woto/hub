# frozen_string_literal: true

module Elastic
  class FeedOffersCount
    include ApplicationInteractor

    class Contract < Dry::Validation::Contract
      params do
        config.validate_keys = true
        required(:feed).maybe(type?: Feed)
      end
    end

    before do
      result = Contract.new.call(context.to_h)
      raise result.inspect if result.failure?
    end

    def call
      query = FeedOffersCountQuery.call(feed: context.feed).object
      context.object = client.count(query)['count']
    end
  end
end
