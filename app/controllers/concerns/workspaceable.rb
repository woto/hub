# frozen_string_literal: true

module Workspaceable
  extend ActiveSupport::Concern
  include Paginatable

  included do
    before_action :set_settings
    before_action :check_defaults
    before_action :set_workspaces
    before_action :set_workspace_form

    private

    def check_defaults
      return if workspace_params.values_at(*self.class::REQUIRED_PARAMS).none?(&:nil?)

      user_default_workspace = policy_scope(Workspace).find_by(
        controller: "tables/#{@settings[:plural]}", is_default: true
      )

      if user_default_workspace
        redirect_to user_default_workspace.path
      else
        redirect_to system_default_workspace
      end
    end

    def set_workspaces
      @workspaces = policy_scope(Workspace).where(controller: "tables/#{@settings[:plural]}")
    end

    def set_workspace_form
      # TODO: check for security
      @workspace_form = WorkspaceForm.new(
        model: params[:controller].split('/').last,
        state: workspace_params.to_json
      )
    end

    def workspace_params
      # NOTE: is there a way to make it better?
      keys = self.class::ALLOWED_PARAMS.map { |item| item.is_a?(Hash) ? item.keys.first : item }
      params.permit(*self.class::ALLOWED_PARAMS).slice(*keys)
    end
  end
end
