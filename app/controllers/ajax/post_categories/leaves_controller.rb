# frozen_string_literal: true

module Ajax
  module PostCategories
    class LeavesController < ApplicationController
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
                    title.autocomplete^2
                    title.autocomplete._2gram^2
                    title.autocomplete._3gram^2
                    path.autocomplete
                    path.autocomplete._2gram
                    path.autocomplete._3gram
                  ]
                }
              },
              filter: [
                {
                  term: {
                    leaf: true
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
