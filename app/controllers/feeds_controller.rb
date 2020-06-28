class FeedsController < ApplicationController
  layout 'dashboard'
  skip_before_action :authenticate_user!

  def index; end
end
