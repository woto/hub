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
    end

    def by_month
      month = Time.use_zone('UTC') { Time.zone.parse("#{params[:month]}-01") }
      get_index(required_fields, month: month)
    end

    def by_tag
      get_index(required_fields, tag: params[:tag])
    end

    def by_category
      @post_category = PostCategory.find_by(id: params[:category_id])
      get_index(required_fields, post_category_id: params[:category_id])
    end

    private

    def required_fields
      %w[id intro published_at tags]
    end

    def set_settings
      @settings = GlobalHelper.class_configurator('article')
    end

    def system_default_workspace
      url_for(**workspace_params,
              columns: @settings[:form_class]::DEFAULTS,
              per: @pagination_rule.per,
              sort: :published_at,
              order: :desc)
    end

    def path_for_switch_language(locale)
      realm = Realm.news.find_by(locale: locale)
      if realm
        articles_url(host: realm.domain)
      else
        '/404'
      end
    end
  end
end
