# frozen_string_literal: true

module Table
  class BaseController < ApplicationController
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
end
