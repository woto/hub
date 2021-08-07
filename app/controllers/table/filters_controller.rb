# frozen_string_literal: true

# TODO: to test isolated

module Table
  class FiltersController < ApplicationController
    skip_before_action :authenticate_user!

    def create
      @settings = GlobalHelper.class_configurator(filter_form_params[:model])
      @elastic_column = @settings[:form_class].elastic_column(filter_form_params[:column])
      filter_form_class = "Filters::#{@elastic_column[:type].to_s.camelize}Form".constantize
      tmp = JSON.parse(filter_form_params[:state]).dig('filters', filter_form_params[:column])
      @filter_form = filter_form_class.new(filter_form_params.merge(tmp))
      # column_settings = @settings[:form_class].get_column_settings(filter_form_params[:column])

      respond_to do |format|
        format.json
      end
    end

    def update
      @settings = GlobalHelper.class_configurator(filter_form_params[:model])
      @elastic_column = @settings[:form_class].elastic_column(filter_form_params[:column])
      filter_form_class = "Filters::#{@elastic_column[:type].to_s.camelize}Form".constantize

      @filter_form = filter_form_class.new(filter_form_params)
      if @filter_form.valid?
        redirect_to url_for(params_for_url), status: :see_other
      else
        render :create, status: :unprocessable_entity
      end
    end

    private

    def params_for_url
      {
        'controller' => "/tables/#{filter_form_params[:model]}",
        **JSON.parse(filter_form_params[:state]).deep_merge(
          'filters' => {
            filter_form_params[:column] => filter_form_params.except('state', 'model', 'column')
          }
        ),
        only_path: true
      }
    end

    def filter_form_params
      params.require(:filter_form).permit!
    end
  end
end


