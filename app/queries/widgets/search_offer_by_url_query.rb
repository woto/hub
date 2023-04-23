# frozen_string_literal: true

class Widgets::SearchOfferByUrlQuery
  include ApplicationInteractor

  contract do
    params do
      required(:url).maybe(:string)
    end
  end

  def call
    body = Jbuilder.new do |json|
      json.query do
        json.term do
          json.set! "url.#{Import::Offers::HashifyInteractor::HASH_BANG_KEY}.keyword", context.url
        end
      end
    end

    context.object = {
      body: body.attributes!.deep_symbolize_keys,
      index: Elastic::IndexName.pick('offers').scoped,
      # routing: context.feed.id
    }

  end
end
