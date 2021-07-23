# frozen_string_literal: true

module Table
  class WorkspacesController < ApplicationController
    def create
      @workspace_form = policy_scope(Workspace).new(workspace_params)
      redirect_to(path) if @workspace_form.save
    end

    def destroy
      policy_scope(Workspace).find(params[:id]).destroy!
      redirect_to(path)
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

    def workspace_params
      params.require(:workspace_form).permit(:name, :is_default)
            .merge(controller: params[:model], path: path)
    end
  end
end
