# frozen_string_literal: true

module Table
  class ColumnsController < ApplicationController
    skip_before_action :authenticate_user!

    def create
      # TODO: to secure
      @settings = GlobalHelper.class_configurator(columns_form_params[:model])
      @columns_form = @settings[:form_class].new(columns_form_params)
      return unless @columns_form.valid?

      redirect_to url_for(params_for_url)
    end

    private

    # TODO: to secure
    def params_for_url
      {
        'controller' => "/tables/#{columns_form_params[:model]}",
        **JSON.parse(columns_form_params[:state]).merge(
          'columns' => columns_form_params[:displayed_columns].compact_blank
        ),
        'only_path' => true
      }
    end

    def columns_form_params
      params.require(:columns_form).permit(:model, :state, displayed_columns: [])
    end
  end
end
