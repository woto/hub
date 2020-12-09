# frozen_string_literal: true

class Tables::FeedsController < ApplicationController
  ALLOWED_PARAMS = [:q, :per, :page, :sort, :order, :cols]
  REQUIRED_PARAMS = [:per, :cols]

  include Workspaceable
  include Tableable
  layout 'backoffice'
  before_action :set_feed, only: %i[show edit update destroy]
  skip_before_action :authenticate_user!

  def index
    get_index(['advertiser_id', 'index_name'], nil)
  end

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
    client = Elasticsearch::Client.new Rails.application.config.elastic
    index_name = Elastic::IndexName.offers(params[:id])
    render json: client.count(index: index_name)
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

  def set_settings
    @settings = { singular: :feed,
                  plural: :feeds,
                  model_class: Feed,
                  form_class: Columns::FeedForm,
                  query_class: FeedsSearchQuery,
                  decorator_class: FeedDecorator
    }
  end

  def system_default_workspace
    url_for(**workspace_params,
            cols: @settings[:form_class].default_stringified_columns_for(request),
            per: @pagination_rule.per,
            sort: :id,
            order: :desc)
  end
end
