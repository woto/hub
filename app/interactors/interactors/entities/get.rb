# frozen_string_literal: true

module Interactors
  module Entities
    class Get
      include ApplicationInteractor

      def call
        entity = Entity.find(context.id)

        context.object = {
          id: entity.id,
          title: entity.title,
          aliases: entity.aliases,
          image: entity.image ? entity.image.derivation_url(:thumbnail, 50, 50) : '',
          user_id: entity.user_id,
          created_at: entity.created_at,
          updated_at: entity.updated_at,
          mentions_count: entity.mentions_count
        }
      end
    end
  end
end
