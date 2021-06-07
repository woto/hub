# frozen_string_literal: true

module Ajax
  class UsersController < ApplicationController

    def index
      authorize %i[ajax users]

      body = {
        query: {
          bool: {
            must: {
              multi_match: {
                query: params[:q],
                type: 'bool_prefix',
                fields: %w[
                  email.autocomplete
                  email.autocomplete._2gram
                  email.autocomplete._3gram
                ]
              }
            }
          }
        },
        size: 30
      }

      @users = User.__elasticsearch__.search(body)

      respond_to do |format|
        format.json
      end
    end
  end
end
