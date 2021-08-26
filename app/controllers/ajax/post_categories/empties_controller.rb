# frozen_string_literal: true

module Ajax
  module PostCategories
    class EmptiesController < ApplicationController
      def index
        authorize %i[ajax post_categories]

        body = {
          query: {
            bool: {
              must: {
                multi_match: {
                  query: params[:q],
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
                    realm_id: params[:realm_id]
                  }
                }
              ]
            }
          },
          size: 30
        }

        @categories = PostCategory.__elasticsearch__.search(body)

        respond_to do |format|
          format.json
        end
      end
    end
  end
end
