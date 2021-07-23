# frozen_string_literal: true

class Table::ColumnsController < ApplicationController
  skip_before_action :authenticate_user!

  def create
    # seems not too secure
    form_class = "Columns::#{params[:model].camelize.demodulize.singularize}Form".constantize

    strings = params[:columns_form][:displayed_columns]
    ints = form_class.strings_to_ints(strings).join('.')

    url_opts = path_opts.merge(cols: ints)
    redirect_to url_for(url_opts)
  end

  private

  def path_opts
    opts = request.params.slice(*GlobalHelper.workspace_params)
    opts[:controller] = "/#{params[:model]}"
    opts
  end

  def path
    url_for(**path_opts, only_path: true)
  end
end
