# frozen_string_literal: true

module Table
  class WorkspacesController < ApplicationController
    before_action :set_workspace, only: %i[destroy]

    def create
      @workspace_form = WorkspaceForm.new(workspace_form_params)
      return unless @workspace_form.valid?

      create_workspace!(@workspace_form)
      redirect_to(params_for_url)
    end

    def destroy
      GlobalHelper.retryable do
        authorize(@workspace)

        if @workspace.destroy
          redirect_back fallback_location: dashboard_path, notice: t('.workspace_was_successfully_destroyed')
        else
          redirect_back fallback_location: dashboard_path, alert: @workspace.errors.full_messages.join
        end
      end
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

    private

    def set_workspace
      @workspace = Workspace.find(params[:id])
    end
  end
end
