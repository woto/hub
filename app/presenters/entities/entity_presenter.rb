# frozen_string_literal: true

module Entities
  class EntityPresenter
    include ApplicationInteractor

    delegate :entity, to: :context

    def call
      context.object = {
        entity_id: entity.id,
        title: entity.title,
        intro: entity.intro,
        lookups: entity.lookups.map { |lookup| { id: lookup.id, title: lookup.title } },
        kinds: entity.topics.map { |topic| { id: topic.id, title: topic.title } },
        images: GlobalHelper.image_hash(entity.images).map do |image|
          {
            id: image['id'],
            image_url: ImageUploader::IMAGE_TYPES.include?(image['mime_type']) ? image['images']['100'] : nil,
            video_url: ImageUploader::VIDEO_TYPES.include?(image['mime_type']) ? image['videos']['100'] : nil,
            dark: image['dark']
          }
        end,
        entities_mentions_count: entity.entities_mentions_count
      }
    end
  end
end
