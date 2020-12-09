# frozen_string_literal: true

class Table::ColumnsController < ApplicationController
  skip_before_action :authenticate_user!

  def create
    url_opts = request.params.slice(*GlobalHelper.workspace_params)
    url_opts[:controller] = "/#{params[:model]}"
    ints = params[:columns_form][:displayed_columns]
    # seems not too secure
    form_class = "Columns::#{params[:model].camelize.demodulize.singularize}Form".constantize
    url_opts[:cols] = form_class.strings_to_ints(ints).join('.')
    redirect_to url_for(url_opts)
  end
end
