class HomepageController < ApplicationController
  # skip_after_action :verify_policy_scoped
  layout 'homepage'
  skip_before_action :authenticate_user!

  def index; end
end
