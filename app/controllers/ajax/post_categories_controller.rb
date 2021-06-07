# frozen_string_literal: true

class Ajax::PostCategoriesController < ApplicationController
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
