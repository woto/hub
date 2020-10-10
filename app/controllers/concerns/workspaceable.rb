module Workspaceable
  extend ActiveSupport::Concern

  included do
    before_action :set_settings, only: :index
    before_action :set_pagination_rule
    before_action :check_defaults, only: :index
    before_action :set_workspaces, only: :index
    before_action :set_workspace_form, only: :index

    private

    def check_defaults
      if workspace_params.values_at(*self.class::REQUIRED_PARAMS).any? { _1.nil? }
        redirect_with_defaults
      end
    end

    def set_workspaces
      @workspaces = policy_scope(Workspace.where(controller: @settings[:plural]))
    end

    def set_workspace_form
      @workspace_form = Workspace.new
    end

    def workspace_params
      params.permit(*self.class::ALLOWED_PARAMS).slice(*self.class::ALLOWED_PARAMS)
    end
  end
end
