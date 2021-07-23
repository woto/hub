# frozen_string_literal: true

module Table
  class ColumnsController < BaseController
    skip_before_action :authenticate_user!

    def create
      # seems not too secure
      form_class = "Columns::#{params[:model].camelize.demodulize.singularize}Form".constantize

      strings = params[:columns_form][:displayed_columns]
      ints = form_class.strings_to_ints(strings).join('.')

      url_opts = path_opts.merge(cols: ints)
      redirect_to url_for(url_opts)
    end
  end
end
