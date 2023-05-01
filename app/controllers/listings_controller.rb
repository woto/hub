class ListingsController < ApplicationController
  layout 'roastme/pages'
  skip_before_action :authenticate_user!, only: [:show]

  def show
    @draft = ::Mentions::IndexInteractor.call(
      current_user:,
      params: { listing_id: params[:id] }
    ).object
  end
end
