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
                    lookups
                  ]
                }
              }
            }
          },
          size: 3
        }

        context.object = Entity.__elasticsearch__.search(body)
      end
    end
  end
end
