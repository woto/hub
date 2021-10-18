# frozen_string_literal: true

class FeedsController < ApplicationController
  layout 'backoffice'
  before_action :set_feed, only: %i[show edit update destroy shinked]
  skip_before_action :authenticate_user!

  def new
    @feed = Feed.new
  end

  def create
    @feed = Feed.new(feed_params)
    @feed.operation = 'manual'

    if @feed.save
      redirect_to @feed, notice: 'Feed was successfully created.'
    else
      render :new
    end
  end

  # NOTE: not tested
  def shrinked
    result = []

    Production::ShrinkedFeed.call(feed: Feed.find(params[:id]), size: 100).object['hits']['hits'].each do |category|
      category['inner_hits']['fuck']['hits']['hits'].each do |offer|
        result << {
          id: offer['_id'],
          category_id: offer['_source']['feed_category_id'],
          images: offer['_source']['picture']&.map { |picture| picture['#'] },
          title: offer['_source'].dig('name', 0, '#'),
          description: offer['_source'].dig('description', 0, '#'),
          url: offer['_source'].dig('url', 0, '#')
        }
      end
    end
    render json: result
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
    render json: Feed.with_log_data.find(params[:id]).log_data
  end

  private

  def set_feed
    @feed = Feed.find(params[:id])
  end

  def feed_params
    params.require(:feed).permit(:name, :url, :advertiser_id)
  end
end
