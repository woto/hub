# frozen_string_literal: true

class FeedOffersCountQuery
  include ApplicationInteractor

  contract do
    params do
      config.validate_keys = true
      required(:feed).value(type?: Feed)
    end
  end

  def call
    body = Jbuilder.new do |json|
      json.query do
        json.term do
          json.feed_id context.feed.id
        end
      end
    end

    context.object = {
      body: body.attributes!.deep_symbolize_keys,
      index: Elastic::IndexName.offers,
      routing: context.feed.id
    }
  end
end
