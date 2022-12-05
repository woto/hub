class Roastme::TinderController < ApplicationController
  skip_before_action :authenticate_user!
  layout 'roastme/pages'

  def index

  end
end
