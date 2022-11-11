class ListingsController < ApplicationController
  layout 'roastme/pages'
  skip_before_action :authenticate_user!, only: [:show]

  def show
  end
end
