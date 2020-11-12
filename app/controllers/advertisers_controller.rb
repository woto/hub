# frozen_string_literal: true

class AdvertisersController < ApplicationController
  layout 'backoffice'
  before_action :set_advertiser, only: %i[show edit update destroy]
  skip_before_action :authenticate_user!
  before_action { prepend_view_path Rails.root + 'app' + 'views/template' }

  def new
    @advertiser = Advertiser.new
  end

  def create
    @advertiser = Advertiser.new(advertiser_params)

    if @advertiser.save
      redirect_to @advertiser.becomes(Advertiser), notice: 'Advertiser was successfully created.'
    else
      render :new
    end
  end

  def show
    respond_to do |format|
      format.json { render json: @advertiser }
      format.html
    end
  end

  private

  def set_advertiser
    @advertiser = Advertiser.find(params[:id])
  end

  def advertiser_params
    params.require(:advertiser).permit(:name, :ext_id, :type)
  end
end
