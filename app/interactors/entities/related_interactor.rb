# frozen_string_literal: true

module Entities
  class RelatedInteractor
    include ApplicationInteractor

    contract do
      params do
        optional(:q)
        optional(:entity_ids)
        optional(:entity_title)
      end
    end

    def call
      query = RelatedQuery.call(
        entity_ids: context.entity_ids,
        q: context.q,
        from: 0,
        size: 50
      ).object

      popular_filtered_entities = GlobalHelper.elastic_client.search(query).then do |res|
        res['aggregations']['group']['group']['buckets']
      end

      query = AutocompleteQuery.call(
        entity_ids: popular_filtered_entities.pluck('key'),
        q: context.entity_title,
        from: 0,
        size: 50
      ).object

      matched_entities = GlobalHelper.elastic_client.search(query)
      sorted_matched_entities = matched_entities['hits']['hits'].sort_by do |entity|
        popular_filtered_entities.pluck('key').index(entity['_id'].to_i)
      end

      context.object = sorted_matched_entities.map do |entity|
        EntityPresenter.call(
          id: entity['_id'],
          title: entity['_source']['title'],
          intro: entity['_source']['intro'],
          lookups: entity['_source']['lookups'],
          kinds: entity['_source']['topics'],
          images: entity['_source']['images'].map do |image|
            {
              id: image['id'],
              image_url: ImageUploader::IMAGE_TYPES.include?(image['mime_type']) ? image['images']['200'] : nil,
              video_url: ImageUploader::VIDEO_TYPES.include?(image['mime_type']) ? image['videos']['200'] : nil,
              width: image['width'],
              height: image['height'],
              dark: image['dark']
            }
          end,
          created_at: entity['_source']['created_at'],
          entities_mentions_count: entity['_source']['entities_mentions_count'],
          entity_url: Rails.application.routes.url_helpers.entity_url(
            entity['_id'], host: GlobalHelper.host, locale: nil
          ),
          links: entity['_source']['link_url'].uniq.compact
        ).object
      end
    end
  end
end
