# frozen_string_literal: true

module Decorators
  module Mentions
    class Entities
      include ApplicationInteractor

      def call
        context.object = context.object.map do |entity|
          {
            id: entity.id,
            title: entity.title,
            lookups: entity.lookups.reject(&:empty?),
            score: entity._score,
            image: entity.image.presence || ApplicationController.helpers.asset_pack_path('media/images/icon-404-50.png')
          }
        end
      end
    end
  end
end
