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
            topics: entity.topics.reject(&:empty?),
            score: entity._score,
            image: entity.image
          }
        end
      end
    end
  end
end
