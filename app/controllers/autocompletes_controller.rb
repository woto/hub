# frozen_string_literal: true

class AutocompletesController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    model = params[:model]
    col_name = params[:col_name]
    q = params[:q]

    body = {
      query: {
        multi_match: {
          query: params[:q],
          type: 'bool_prefix',
          fields: %W[
            #{col_name}.autocomplete
            #{col_name}.autocomplete._2gram
            #{col_name}.autocomplete._3gram
          ]
        }
      }
    }

    # body = {
    #   suggest: {
    #     col_name => {
    #       'prefix' => q,
    #       'completion' => {
    #         'field' => col_name,
    #         'size': 5,
    #         "skip_duplicates": true,
    #         "fuzzy": { "fuzziness": 5 }
    #       }
    #     }
    #   }
    # }
    #
    result = model.constantize.__elasticsearch__.search(body)
    p 1
    # debugger
    respond_to do |format|
      format.json { render json: result.results.map { |doc| { title: doc._source[col_name] } } }
    end

    # respond_to do |format|
    #   format.json { render json: result.suggestions[col_name][0].options.map { { title: _1._source[col_name] } } }
    # end
  end
end
