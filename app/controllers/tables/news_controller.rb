# frozen_string_literal: true

module Tables
  class NewsController < ApplicationController
    ALLOWED_PARAMS = %i[q per page sort order].freeze
    REQUIRED_PARAMS = [:per].freeze

    include Workspaceable
    include Tableable
    layout 'backoffice'
    skip_before_action :authenticate_user!

    helper_method :by_months_menu, :by_tags_menu

    def index
      get_index([], nil)
    end

    def show
      # repository = NewsRepository.new
      #  @news = repository.find(params[:id])
      @news = Post.find(params[:id])
    end

    private

    def by_months_menu
      client = Elasticsearch::Client.new Rails.application.config.elastic
      client.search(
        index: Elastic::IndexName.posts,
        body: {
          "size": 0,
          "aggs": {
            "group_by_month": {
              "date_histogram": {
                "field": 'created_at',
                "calendar_interval": 'month',
                "order": { "_key": 'desc' }
              }
            }
          }
        }
      )
    end

    def by_tags_menu
      client = Elasticsearch::Client.new Rails.application.config.elastic
      client.search(
        index: Elastic::IndexName.posts,
        body: {
          "size": 0,
          "aggs": {
            "group_by_tag": {
              "terms": { "field": "tags.keyword" }
            }
          }
        }
      )
    end

    def set_settings
      @settings = { singular: :news,
                    plural: :news,
                    model_class: News,
                    form_class: Columns::NewsForm,
                    query_class: NewsSearchQuery,
                    decorator_class: NewsDecorator }
    end

    def system_default_workspace
      url_for(**workspace_params,
              per: @pagination_rule.per,
              sort: :published_at,
              order: :desc)
    end
  end
end
