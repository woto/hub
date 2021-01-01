# frozen_string_literal: true

module Tables
  class NewsController < ApplicationController
    ALLOWED_PARAMS = %i[q per page sort order].freeze
    REQUIRED_PARAMS = %i[per order sort].freeze

    include Workspaceable
    include Tableable
    layout 'backoffice'
    skip_before_action :authenticate_user!

    # GET /news
    def index
      get_index([])
    end

    def by_month
      get_index([], month: Time.zone.parse("#{params[:month]}-01"))
    end

    def by_tag
      get_index([], tag: params[:tag])
    end

    private

    def set_settings
      @settings = { singular: :news,
                    plural: :news,
                    model_class: News,
                    form_class: Columns::NewsForm,
                    query_class: NewsSearchQuery,
                    decorator_class: NewsDecorator
      }
    end

    def system_default_workspace
      url_for(**workspace_params,
              per: @pagination_rule.per,
              sort: :published_at,
              order: :desc)
    end

    def set_preserved_search_params
      @preserved_search_params = %i[order per sort q]
    end

    def path_for_switch_language(locale)
      news_index_path(locale)
    end
  end
end
