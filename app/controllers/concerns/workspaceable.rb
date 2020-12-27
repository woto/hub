module Workspaceable
  extend ActiveSupport::Concern
  include Paginatable
  include SearchBarable

  included do
    before_action :set_settings
    before_action :check_defaults
    before_action :set_workspaces
    before_action :set_workspace_form

    private

    def check_defaults
      if workspace_params.values_at(*self.class::REQUIRED_PARAMS).any? { _1.nil? }
        user_default_workspace = Workspace.find_by(controller: "tables/#{@settings[:plural]}", is_default: true)
        if user_default_workspace
          redirect_to user_default_workspace.path
        else
          redirect_to system_default_workspace
        end
      end
    end

    def set_workspaces
      @workspaces = policy_scope(Workspace.where(controller: "tables/#{@settings[:plural]}"))
    end

    def set_workspace_form
      @workspace_form = Workspace.new
    end

    def workspace_params
      params.permit(*self.class::ALLOWED_PARAMS).slice(*self.class::ALLOWED_PARAMS)
    end
  end
end
