# frozen_string_literal: true

class HomeController < ApplicationController
  # skip_after_action :verify_policy_scoped
  layout 'home'
  skip_before_action :authenticate_user!

  def index; end
end
