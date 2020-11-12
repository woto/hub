# frozen_string_literal: true

class FeedsController < ApplicationController
  ALLOWED_PARAMS = [:q, :per, :page, :sort, :order, :cols]
  REQUIRED_PARAMS = [:per, :cols]

  include Workspaceable
  layout 'backoffice'
  before_action :set_feed, only: %i[show edit update destroy]
  skip_before_action :authenticate_user!
  before_action { prepend_view_path Rails.root + 'app' + 'views/template' }
  before_action { prepend_view_path Rails.root + 'app' + 'views/table' }

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

  def index
    feeds = Feed.__elasticsearch__.search(
      params[:q].presence || '*',
      _source: Columns::FeedForm.parsed_columns_for(request) + ['advertiser_id', 'index_name'],
      sort: "#{params[:sort]}:#{params[:order]}"
    ).page(@pagination_rule.page).per(@pagination_rule.per)

    favorites = Contexts::Favorites.new(current_user, feeds)
    @feeds = OfferDecorator.decorate_collection(feeds, context: { favorites: favorites })

    render 'empty_page' and return if @feeds.empty?

    @columns_form = Columns::FeedForm.new(displayed_columns: Columns::FeedForm.parsed_columns_for(request))
    render 'index', locals: { rows: @feeds }
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
                  form_class: Columns::FeedForm }
  end

  def system_default_workspace
    url_for(**workspace_params,
            cols: @settings[:form_class].default_stringified_columns_for(request),
            per: @pagination_rule.per,
            sort: :id,
            order: :desc)
  end
end
