# frozen_string_literal: true

module Interactors
  module Mentions
    class Entities
      include ApplicationInteractor

      def call
        body = {
          query: {
            bool: {
              must: {
                multi_match: {
                  query: context.q,
                  type: 'bool_prefix',
                  fields: %w[
                    title.autocomplete
                    title.autocomplete._2gram
                    title.autocomplete._3gram
                    aliases
                  ]
                }
              }
            }
          },
          size: 30
        }

        entities = Entity.__elasticsearch__.search(body)

        context.object = entities.map do |entity|
          {
            id: entity.id,
            title: entity.title,
            aliases: entity.aliases.reject(&:empty?),
            score: entity._score,
            image: entity.image.present? ? entity.image : ApplicationController.helpers.asset_pack_path('media/images/icon-404-50.png')
          }
        end
      end
    end
  end
end
