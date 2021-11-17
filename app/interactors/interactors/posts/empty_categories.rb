# frozen_string_literal: true

module Interactors
  module Posts
    class EmptyCategories
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
                  ]
                }
              },
              filter: [
                {
                  term: {
                    posts_count: 0
                  }
                },
                {
                  term: {
                    realm_id: context.realm_id
                  }
                }
              ]
            }
          },
          size: 30
        }

        categories = PostCategory.__elasticsearch__.search(body)

        context.object = categories.map do |category|
          {
            id: category.id,
            path: category.path.join(' > '),
            title: category.title
          }
        end
      end
    end
  end
end
