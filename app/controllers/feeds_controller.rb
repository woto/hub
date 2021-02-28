# frozen_string_literal: true

class FeedsController < ApplicationController
  layout 'backoffice'
  before_action :set_feed, only: %i[show edit update destroy]
  skip_before_action :authenticate_user!

  def new
    @feed = Feed.new
  end

  def create
    @feed = Feed.new(feed_params)
    @feed.operation = 'form'

    if @feed.save
      redirect_to @feed, notice: 'Feed was successfully created.'
    else
      render :new
    end
  end

  def count
    raise 'does not work'
    client = Elasticsearch::Client.new Rails.application.config.elastic
    json = client.count(
      FeedOffersCountQuery.call(
        feed_id: params[:id]
      ).object
    )
    render json: json
  end

  def prioritize
    Feed.increment_counter(:priority, params[:id])
  end

  # TODO: check necessity of method's body
  def show
    respond_to do |format|
      format.json { render json: @feed }
      format.html
    end
  end

  def logs
    render json: Feed.find(params[:id]).feed_logs.order(id: :desc).limit(20)
  end

  private

  def set_feed
    @feed = Feed.find(params[:id])
  end

  def feed_params
    params.require(:feed).permit(:name, :url, :advertiser_id)
  end
end
