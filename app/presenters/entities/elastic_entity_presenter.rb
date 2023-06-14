# frozen_string_literal: true

module Entities
  class ElasticEntityPresenter
    include ApplicationInteractor

    # delegate :entity, to: :context

    contract do
      params do
        required(:entity)
        optional(:count)
      end
    end

    def call
      entity = context.entity

      context.object = EntityPresenter.call(
        id: entity['_id'].to_i,
        title: entity['_source']['title'],
        intro: entity['_source']['intro'],
        lookups: entity['_source']['lookups'].map(&:symbolize_keys),
        kinds: entity['_source']['topics'].map(&:symbolize_keys),
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
        links: entity['_source']['link_url'].uniq.compact,
        entity_url: Rails.application.routes.url_helpers.entity_path(
          entity['_id'], host: GlobalHelper.host, locale: nil
        ),
        perfect_match: entity['_score'] > Rails.application.config.global[:perfect_match_score_threshold]
      ).object

      context.object[:count] = context.count if context.count
    end
  end
end
