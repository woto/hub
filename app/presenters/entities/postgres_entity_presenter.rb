# frozen_string_literal: true

module Entities
  class PostgresEntityPresenter
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
        id: entity.id,
        title: entity.title,
        intro: entity.intro,
        lookups: entity.lookups.map { |lookup| { id: lookup.id, title: lookup.title } },
        kinds: entity.topics.map { |topic| { id: topic.id, title: topic.title } },
        images: GlobalHelper.image_hash(entity.images_relations, %w[200]).map do |image|
          {
            id: image['id'].to_i,
            image_url: ImageUploader::IMAGE_TYPES.include?(image['mime_type']) ? image['images']['200'] : nil,
            video_url: ImageUploader::VIDEO_TYPES.include?(image['mime_type']) ? image['videos']['200'] : nil,
            width: image['width'],
            height: image['height'],
            dark: image['dark']
          }
        end,
        created_at: entity.created_at,
        entities_mentions_count: entity.entities_mentions_count,
        links: entity.cites.map(&:link_url).uniq.compact,
        entity_url: Rails.application.routes.url_helpers.entity_path(
          entity, host: GlobalHelper.host, locale: nil
        )
      ).object

      context.object[:count] = context.count if context.count
    end
  end
end
