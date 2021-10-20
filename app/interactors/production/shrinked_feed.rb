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
      context.object = []

      query = Production::ShrinkedFeedQuery.call(feed: context.feed, size: context.size).object
      result = GlobalHelper.elastic_client.search(query)
      result['hits']['hits'].each do |offer|
        id = offer['_id']
        category_id = offer['_source']['feed_category_id']
        images = offer['_source']['picture']&.map { |picture| picture['#'] }
        title = offer['_source'].dig('name', 0, '#')
        description = offer['_source'].dig('description', 0, '#')
        url = offer['_source'].dig('url', 0, '#')
        context.object << {
          id: id,
          category_id: category_id,
          images: images,
          title: title,
          description: description,
          url: url
        }
      end
    end
  end
end
