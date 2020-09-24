# frozen_string_literal: true

class OffersController < ApplicationController
  layout 'backoffice'
  skip_before_action :authenticate_user!

  def index
    if params[:feed_id].present?
      @feed = Feed.find(params[:feed_id].split('+').second)
      @advertiser = @feed.advertiser
      @all_advertiser_feeds = @advertiser.feeds.order(:name).to_a
    end

    client = Elasticsearch::Client.new Rails.application.config.elastic
    @pr = PaginationRules.new(request, 12, 30, [2, 3, 4, 6, 8, 9, 10, 12, 21, 30, 33, 42])
    # TODO: `:profile`? It doesn't used.
    query = OffersSearchQuery.call(params.slice(:feed_id, :q, :category_id, :only, :explain, :profile)).object
    request = query.merge(from: (@pr.page - 1) * @pr.per, size: @pr.per)
    result = client.search(request)

    hits = result['hits']
    aggregations = result['aggregations']

    @offers = Kaminari
              .paginate_array(hits['hits'], total_count: hits['total']['value'])
              .page(@pr.page)
              .per(@pr.per)

    category_ids = hits['hits'].map { |h| h['_source']['feed_category_ids'] }.flatten
    @all_categories = FeedCategory.find(category_ids).to_a

    if params[:feed_id].present?
      buckets = aggregations['categories']['buckets']
      @left_menu_categories = FeedCategory.find(buckets.map { |b| b['key'] })
                                          .zip(buckets.map { |b| b['doc_count'] })
      @sum_other_doc_count = aggregations['categories']['sum_other_doc_count']
    else
      buckets = aggregations['feeds']['buckets']
      @feeds_with_found_offers = Feed.find(buckets.map { |b| b['key'].split('+').second })
                                     .zip(buckets.map { |b| b['doc_count'] })
      @sum_other_doc_count = aggregations['feeds']['sum_other_doc_count']
    end

    @category = aggregations['category']

    if @category && @category['doc_count'] > 0 && @left_menu_categories.size > 0
      unshift = [
          OpenStruct.new(id: params[:category_id], name: 'Только эта категория', only: true, to_model: FeedCategory.new),
          @category['doc_count']
      ]
      @left_menu_categories.unshift(unshift)
    end



  end

  # def categories
  #   @categories = Rails.cache.fetch("#{params[:feed_id]} #{params[:category_ids]} 1", expires_in: 10.minutes) do
  #     Rails.logger.debug('Categories cache missed')
  #     scope = FeedCategory.where(feed_id: params[:feed_id])
  #     scope = scope.where(id: params[:category_ids]) if params[:category_ids]
  #     scope.select('id, name, ancestry_depth as level, ancestry').order(:name).arrange_serializable.to_json
  #   end
  #
  #   respond_to do |format|
  #     format.json do
  #       render json: @categories
  #     end
  #   end
  # end
end
