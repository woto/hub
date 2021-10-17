# frozen_string_literal: true

# NOTE: not tested
module Production
  class ShrinkedFeedQuery
    include ApplicationInteractor

    contract do
      params do
        config.validate_keys = true
        required(:feed).value(type?: Feed)
        required(:size).filled(:integer)
      end
    end

    def call
      body = Jbuilder.new do |json|
        json.query do
          json.term do
            json.feed_id context.feed.id
          end
        end
        json.collapse do
          json.field "feed_category_id"
          json.inner_hits do
            json.name 'fuck'
            json.size context.size
          end
        end
      end

      context.object = {
        body: body.attributes!.deep_symbolize_keys,
        index: Elastic::IndexName.offers,
        # size: 0,
        routing: context.feed.id
      }
    end
  end
end