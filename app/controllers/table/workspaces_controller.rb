# frozen_string_literal: true

module Table
  class WorkspacesController < ApplicationController
    def create
      workspace = policy_scope(Workspace).new(workspace_params)
      if workspace.save
        redirect_to path
      else
        redirect_back fallback_location: root_path
      end
    end

    def destroy
      policy_scope(Workspace).find(params[:id]).destroy!
      redirect_to path
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
