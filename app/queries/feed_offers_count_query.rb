# frozen_string_literal: true

class FeedOffersCountQuery
  include ApplicationInteractor
  include Elasticsearch::DSL

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
