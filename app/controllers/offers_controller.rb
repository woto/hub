class OffersController < ApplicationController
  layout 'dashboard'
  skip_before_action :authenticate_user!

  def index
    @offers, @total_count = Elastic.call(params)
  end
end
