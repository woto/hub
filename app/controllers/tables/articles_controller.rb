# frozen_string_literal: true

module Tables
  class ArticlesController < ApplicationController
    ALLOWED_PARAMS = [:q, :per, :page, :sort, :order, { filters: {} }, { columns: [] }].freeze
    REQUIRED_PARAMS = %i[per order sort].freeze

    include Workspaceable
    include Tableable
    layout 'website'
    skip_before_action :authenticate_user!

    # GET /news
    def index
      get_index(required_fields)
      response.headers['X-Robots-Tag'] = 'noindex'
    end

    def by_month
      month = Time.use_zone('UTC') { Time.zone.parse("#{params[:month]}-01") }
      get_index(required_fields, month: month)
      response.headers['X-Robots-Tag'] = 'noindex'
    end

    def by_tag
      get_index(required_fields, tag: params[:tag])
      response.headers['X-Robots-Tag'] = 'noindex'
    end

    def by_category
      @post_category = PostCategory.find_by(id: params[:category_id])
      get_index(required_fields, post_category_id: params[:category_id])
      response.headers['X-Robots-Tag'] = 'noindex'
    end


    # TODO: action?!
    def workspace
      OpenStruct.new(
        **workspace_params,
        columns: @settings[:form_class]::DEFAULTS,
        per: @pagination_rule.per,
        sort: 'published_at',
        order: 'desc'
      )
    end

    private

    def required_fields
      %w[id title intro published_at tags]
    end

    def set_settings
      @settings = GlobalHelper.class_configurator('article')
    end

    def path_for_switch_language(locale, kind)
      realm = Realm.find_by(locale: locale, kind: kind)
      if realm
        articles_url(host: realm.domain)
      else
        '/404'
      end
    end
  end
end
