# frozen_string_literal: true

module Entities
  class GetInteractor
    include ApplicationInteractor

    def call
      if context.id.present?
        entity = Entity.find(context.id)
      else
        # TODO: optimize
        entity = Entity.order('RANDOM()').first
      end

      context.object = EntityPresenter.call(
        id: entity.id,
        entity_url: Rails.application.routes.url_helpers.entity_url(entity, host: GlobalHelper.host, locale: nil),
        title: entity.title,
        intro: entity.intro,
        lookups: entity.lookups.map { |lookup| { id: lookup.id, title: lookup.title } },
        kinds: entity.topics.map { |topic| { id: topic.id, title: topic.title } },
        images: GlobalHelper.image_hash(entity.images_relations, %w[200]).map do |image|
          {
            id: image['id'],
            image_url: ImageUploader::IMAGE_TYPES.include?(image['mime_type']) ? image['images']['200'] : nil,
            video_url: ImageUploader::VIDEO_TYPES.include?(image['mime_type']) ? image['videos']['200'] : nil,
            width: image['width'],
            height: image['height'],
            dark: image['dark']
          }
        end,
        entities_mentions_count: entity.entities_mentions_count,
        links: entity.cites.map(&:link_url).uniq.compact
      ).object
    end
  end
end
