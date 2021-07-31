# frozen_string_literal: true

module Table
  class WorkspacesController < ApplicationController
    def create
      @workspace_form = WorkspaceForm.new(workspace_form_params)
      return unless @workspace_form.valid?

      create_workspace!(@workspace_form)
      redirect_to(params_for_url)
    end

    def destroy
      policy_scope(Workspace).find(params[:id]).destroy!
      redirect_back(fallback_location: root_path)
    end

    private

    # TODO: to secure.
    def params_for_url
      {
        controller: "/tables/#{workspace_form_params[:model]}",
        **JSON.parse(workspace_form_params[:state]),
        only_path: true
      }
    end

    def workspace_form_params
      params.require(:workspace_form).permit(:name, :is_default, :model, :state)
    end

    def create_workspace!(workspace_form)
      policy_scope(Workspace).create!(
        name: workspace_form.name,
        is_default: workspace_form.is_default,
        controller: "tables/#{workspace_form.model}",
        path: url_for(params_for_url)
      )
    end
  end
end
