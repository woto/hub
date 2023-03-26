# frozen_string_literal: true

module Entities
  class EntityPresenter
    include ApplicationInteractor

    # delegate :entity, to: :context

    contract do
      params do
        required(:id).filled(:integer)
        required(:entity_url).filled(:string)
        required(:title).maybe(:string)
        required(:intro).maybe(:string)
        required(:lookups)
        required(:kinds)
        required(:images).maybe do
          array(:hash) do
            required(:id).filled(:integer)
            required(:image_url).maybe(:string)
            required(:video_url).maybe(:string)
            required(:width).maybe(:integer)
            required(:height).maybe(:integer)
            required(:dark).maybe(:bool)
          end
        end
        required(:entities_mentions_count)
        required(:links).maybe { array? { each { string? } } }
      end
    end

    def call
      context.object = {
        entity_id: context.id,
        entity_url: context.entity_url,
        title: context.title,
        intro: context.intro,
        lookups: context.lookups,
        kinds: context.kinds,
        images: context.images,
        entities_mentions_count: context.entities_mentions_count,
        links: context.links
      }
    end
  end
end
