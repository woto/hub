# frozen_string_literal: true

class DashboardController < ApplicationController
  # skip_after_action :verify_policy_scoped
  layout 'backoffice'
  skip_before_action :authenticate_user!

  def index; end
end
