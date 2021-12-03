# frozen_string_literal: true

# NOTE: obsolete? was used in popover
module Interactors
  module Entities
    class Get
      include ApplicationInteractor

      def call
        entity = Entity.find(context.id)

        context.object = {
          id: entity.id,
          title: entity.title,
          lookups: entity.lookups.map(&:to_label),
          image: entity.image ? entity.image.derivation_url(:thumbnail, 100, 100) : ApplicationController.helpers.asset_pack_path('media/images/icon-404-100.png'),
          user_id: entity.user_id,
          created_at: entity.created_at,
          updated_at: entity.updated_at,
          mentions_count: entity.mentions_count
        }
      end
    end
  end
end
