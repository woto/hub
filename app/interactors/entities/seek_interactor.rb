# frozen_string_literal: true

module Entities
  class SeekInteractor
    include ApplicationInteractor

    def call
      # sleep 0.5
      fragment = Fragment::Parser.call(fragment_url: context.fragment_url)

      query = ThingsSearchQuery.call(
        fragment: fragment,
        search_string: context.search_string,
        link_url: context.link_url,
        from: (context.pagination_rule.page - 1) * context.pagination_rule.per,
        size: context.pagination_rule.per
      ).object

      Rails.logger.info(query.to_json)

      @entities = GlobalHelper.elastic_client.search(query)

      context.object = @entities['hits']['hits'].map do |entity|
        {
          entity_id: entity['_id'],
          title: entity['_source']['title'],
          intro: entity['_source']['intro'],
          lookups: entity['_source']['lookups'],
          kinds: entity['_source']['topics'],
          images: entity['_source']['images'].map do |image|
            {
              id: image['id'],
              image_url: ImageUploader::IMAGE_TYPES.include?(image['mime_type']) ? image['images']['200'] : nil,
              video_url: ImageUploader::VIDEO_TYPES.include?(image['mime_type']) ? image['videos']['200'] : nil,
              dark: image['dark']
            }
          end,
          created_at: entity['_source']['created_at'],
          entities_mentions_count: entity['_source']['entities_mentions_count']
        }
      end
    end
  end
end
