# frozen_string_literal: true

module Tables
  class OffersController < ApplicationController
    ALLOWED_PARAMS = [:q, :per, :page, :sort, :order, :favorite_id, { filters: {} }, { columns: [] }].freeze
    REQUIRED_PARAMS = %i[per order sort].freeze

    include Workspaceable
    layout 'backoffice'
    skip_before_action :authenticate_user!
    before_action { prepend_view_path "#{Rails.root}appviews/offers" }

    helper_method :url_for_search_inside_advertiser
    helper_method :url_for_search_inside_feed
    helper_method :url_for_search_inside_feed_category

    helper_method :current_advertiser
    helper_method :current_feed
    helper_method :current_feed_category

    def index
      @favorites_store = FavoritesStore.new(current_user)
      @groups_store = GroupsStore.new
      filters = {}
      results = []
      total_count = 0
      actual_count = 0

      if params[:favorite_id]
        @favorite = policy_scope(Favorite.offers).find(params[:favorite_id])

        filter_ids = @favorite.favorites_items._id.pluck('ext_id')
        unless filter_ids.empty?
          filters[:a] = {
            filter_by: '_id',
            filter_id: filter_ids,
            results: []
          }
        end

        filter_ids = @favorite.favorites_items.not__id.pluck('ext_id', 'kind').map do |ext_id, kind|
          "#{kind}:#{ext_id}"
        end
        unless filter_ids.empty?
          filters[:b] = {
            group_by: 'favorite_ids.keyword',
            # group_model: '',
            filter_by: 'favorite_ids.keyword',
            filter_id: filter_ids,
            include: filter_ids,
            results: []
          }
        end
      elsif params[:advertiser_id]
        @favorites_store.append(current_advertiser.id, :advertiser_id)

        filters[:b] = {
          group_by: 'feed_id',
          group_model: 'Feed',
          filter_by: 'advertiser_id',
          filter_id: [params[:advertiser_id]],
          results: [],
          favorite_item_kind: :feed_id
        }
      elsif params[:feed_id]
        @favorites_store.append(current_feed.id, :feed_id)

        filters[:b] = {
          group_by: 'feed_category_id_0',
          group_model: 'FeedCategory',
          filter_by: 'feed_id',
          filter_id: [params[:feed_id]],
          results: [],
          favorite_item_kind: :feed_category_id
        }
      elsif params[:feed_category_id]
        @favorites_store.append(current_feed_category.id, :feed_category_id)

        if current_feed_category.children.none?
          filters[:a] = {
            filter_by: Import::Offers::Category::CATEGORY_ID_KEY.to_s,
            filter_id: [params[:feed_category_id]],
            results: []
          }
        else
          filters[:b] = {
            group_by: "#{Import::Offers::Category::CATEGORY_ID_KEY}_#{current_feed_category.ancestry_depth + 1}",
            group_model: 'FeedCategory',
            filter_by: "#{Import::Offers::Category::CATEGORY_ID_KEY}_#{current_feed_category.ancestry_depth}",
            filter_id: [params[:feed_category_id]],
            results: [],
            favorite_item_kind: :feed_category_id
          }
        end
      else
        filters[:b] = {
          group_by: 'advertiser_id',
          group_model: 'Advertiser',
          results: [],
          favorite_item_kind: :advertiser_id
        }
      end

      if filters[:a]
        result = exec_query(
          filters[:a].merge(
            from: (@pagination_rule.page - 1) * (@pagination_rule.per * GlobalHelper::MULTIPLICATOR),
            size: @pagination_rule.per * GlobalHelper::MULTIPLICATOR
          )
        )

        result['hits']['hits'].in_groups_of(GlobalHelper::MULTIPLICATOR).each do |group|
          products = group.compact

          results << {
            favorite_item_kind: nil,
            ext_id: nil,
            products: products,
            count: nil
          }

          actual_count += 1

          products.each do |product|
            @favorites_store.append(product['_id'], '_id')
          end
        end

        total_count += (result['hits']['total']['value'].to_f / GlobalHelper::MULTIPLICATOR).ceil
      end

      if filters[:b]
        result = exec_query(
          filters[:b].merge(
            from: 0,
            size: 0
          )
        )

        from = (@pagination_rule.page - 1) * @pagination_rule.per
        from = [from - total_count, 0].max
        to = @pagination_rule.per - actual_count
        sliced = result['aggregations'][GlobalHelper::GROUP_NAME.to_s]['buckets'].slice(from, to)
        sliced.each do |group|
          products = group['offers']['hits']['hits']

          if filters[:b][:favorite_item_kind]
            favorite_item_kind = filters[:b][:favorite_item_kind]
            ext_id = group['key']
          else
            favorite_item_kind = group['key'].split(':').first
            ext_id = group['key'].split(':').second
          end

          results << {
            favorite_item_kind: favorite_item_kind,
            ext_id: ext_id,
            products: products,
            count: group['doc_count']
          }

          @favorites_store.append(ext_id, favorite_item_kind)
          @groups_store.append(ext_id, favorite_item_kind)
          products.each do |product|
            @favorites_store.append(product['_id'], '_id')
          end
        end

        total_count += result['aggregations'][GlobalHelper::GROUP_NAME.to_s]['buckets'].count
      end

      @results = Kaminari
                 .paginate_array(results, total_count: total_count)
                 .page(@pagination_rule.page)
                 .per(@pagination_rule.per)
    end

    private

    def exec_query(filter)
      context = {
        q: params[:q],
        from: filter[:from],
        size: filter[:size],
        group_by: filter[:group_by],
        filter_by: filter[:filter_by],
        filter_id: filter[:filter_id],
        languages: params[:languages],
        include: filter[:include]
      }

      query = OffersSearchQuery.call(context).object
      Rails.cache.fetch(query.to_s, expires_in: 10.seconds) do
        GlobalHelper.elastic_client.search(query)
      end
    end

    def current_advertiser
      return @current_advertiser if defined? @current_advertiser

      @current_advertiser = if params[:advertiser_id]
                              Advertiser.find(params[:advertiser_id])
                            elsif current_feed
                              current_feed.advertiser
                            elsif current_feed_category
                              @current_feed_category
                            end
    end

    def current_feed
      return @current_feed if defined? @current_feed

      @current_feed = if params[:feed_id]
                        Feed.find(params[:feed_id])
                      elsif current_feed_category
                        current_feed_category.feed
                      end
    end

    def current_feed_category
      return @current_feed_category if defined? @current_feed_category

      @current_feed_category = (FeedCategory.find(params[:feed_category_id]) if params[:feed_category_id])
    end

    def set_settings
      @settings = GlobalHelper.class_configurator('offer')
    end

    def set_pagination_rule
      @pagination_rule = PaginationRules.new(
        request, 12, 80, [2, 3, 4, 6, 8, 9, 10, 12, 21, 30, 33, 42, 80])
    end

    def system_default_workspace
      url_for(**workspace_params,
              per: @pagination_rule.per,
              sort: :id,
              order: :desc)
    end

    def url_for_search_everywhere
      offers_url(preserved_params)
    end

    def url_for_search_inside_advertiser
      advertiser_offers_url(advertiser_id: current_advertiser.id, **preserved_params) if current_advertiser
    end

    def url_for_search_inside_feed
      feed_offers_url(feed_id: current_feed.id, **preserved_params) if current_feed
    end

    def url_for_search_inside_feed_category
      if current_feed_category
        feed_category_offers_url(feed_category_id: current_feed_category,
                                 **preserved_params.merge)
      end
    end

    def preserved_params
      request.params.slice(:order, :per, :sort, :columns, :favorite_id)
    end
  end
end
