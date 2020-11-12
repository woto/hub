# frozen_string_literal: true

class OffersController < ApplicationController
  ALLOWED_PARAMS = [:q, :per, :page, :sort, :order, :cols, :category_id]
  REQUIRED_PARAMS = [:per]

  include Workspaceable
  layout 'backoffice'
  skip_before_action :authenticate_user!
  before_action { prepend_view_path Rails.root + 'app' + 'views/offers' }

  def index
    client = Elasticsearch::Client.new Rails.application.config.elastic
    query = OffersSearchQuery.call(params.slice(:feed_id, :q, :category_id, :only, :explain)).object
    request = query.merge(from: (@pagination_rule.page - 1) * @pagination_rule.per, size: @pagination_rule.per)
    result = client.search(request)

    hits = result['hits']
    aggregations = result['aggregations']

    @all_offers_advertiser_ids = []
    @all_offers_feed_ids = []

    hits['hits'].each do |h|
      @all_offers_advertiser_ids << h['_source']['advertiser_id']
      @all_offers_feed_ids << h['_source']['feed_id']
    end

    @all_offers_advertisers = Advertiser.find(@all_offers_advertiser_ids.uniq)
    @all_offers_feeds = Feed.where(id: @all_offers_feed_ids.uniq).includes(:advertiser)

    if params[:feed_id].present?
      # @feed = Feed.find(params[:feed_id].split('+').second)
      @feed = @all_offers_feeds.find { |f| f.id == params[:feed_id].split('+').second.to_i }
      @advertiser = @feed&.advertiser || Advertiser.find(params[:feed_id].split('+').first.to_i)
      # TODO: sometimes elastic index is absent and clicking on dropdown link (in breadcrumbs) leads to exception
      @all_advertiser_feeds = @advertiser.feeds.order(:name).to_a
    end

    # hits['hits'] = hits['hits'].map { |h| h['inner_hits']['top5']['hits']['hits']}.flatten

    offers = Kaminari
              .paginate_array(hits['hits'], total_count: hits['total']['value'])
              .page(@pagination_rule.page)
              .per(@pagination_rule.per)

    favorites = Contexts::Favorites.new(current_user, offers)
    @offers = OfferDecorator.decorate_collection(offers, context: { favorites: favorites })

    category_ids = hits['hits'].map { |h| h['_source']['feed_category_ids'] }.flatten
    @all_categories = FeedCategory.where(id: category_ids).to_a

    if params[:feed_id].present?
      buckets = aggregations['categories']['buckets']
      @left_menu_categories = FeedCategory.find(buckets.map { |b| b['key'] })
                                          .zip(buckets.map { |b| b['doc_count'] })
      @sum_other_doc_count = aggregations['categories']['sum_other_doc_count']
    else
      buckets = aggregations['feeds']['buckets']
      @feeds_with_found_offers = []
      @feeds_with_found_offers = Feed.find(buckets.map { |b| b['key'] })
                                     .zip(buckets.map { |b| b['doc_count'] })
      @sum_other_doc_count = aggregations['feeds']['sum_other_doc_count']
    end

    @category = aggregations['category']

    if @category && (@category['doc_count']).positive? && @left_menu_categories.size.positive?
      unshift = [
        OpenStruct.new(id: params[:category_id], name: 'Только эта категория', only: true, to_model: FeedCategory.new),
        @category['doc_count']
      ]
      @left_menu_categories.unshift(unshift)
    end
  end

  private

  def set_settings
    @settings = { singular: :offer,
                  plural: :offers,
                  # model_class: Offer,
                  form_class: Columns::OfferForm }
  end

  def set_pagination_rule
    @pagination_rule = PaginationRules.new(request, 12, 30, [2, 3, 4, 6, 8, 9, 10, 12, 21, 30, 33, 42])
  end

  def system_default_workspace
    url_for(**workspace_params,
            per: @pagination_rule.per,
            sort: :id,
            order: :desc)
  end
end
