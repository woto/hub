# frozen_string_literal: true

class Ajax::PostTagsController < ApplicationController
  def index
    authorize %i[ajax post_tags]

    body = {
      size: 0,
      aggregations: {
        grouped_documents: {
          filter: {
            bool: {
              must: {
                multi_match: {
                  query: params[:q].to_s,
                  type: 'bool_prefix',
                  fields: %w[tags.autocomplete tags.autocomplete._2gram tags.autocomplete._3gram]
                }
              },
              filter: [
                {
                  term: {
                    realm_id: params[:realm_id]
                  }
                }
              ]
            }
          },
          aggregations: {
            grouped_tags: {
              terms: {
                field: 'tags.keyword',
                size: 100
              }
            }
          }
        }
      }
    }

    @tags = Post.__elasticsearch__.search(body)

    respond_to do |format|
      format.json
    end
  end
end
