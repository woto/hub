# frozen_string_literal: true

module Tables
  class HelpController < ApplicationController
    ALLOWED_PARAMS = %i[q per page sort order].freeze
    REQUIRED_PARAMS = [:per].freeze

    include Workspaceable
    include Tableable
    layout 'backoffice'
    skip_before_action :authenticate_user!

    helper_method :by_tags_menu, :by_categories_menu

    def index
      get_index([], nil)
    end

    def show
      @help = Post.find(params[:id])
    end

    private

    def by_tags_menu
      client = Elasticsearch::Client.new Rails.application.config.elastic
      client.search(
        index: Elastic::IndexName.posts,
        body: {
          "size": 0,
          "aggs": {
            "group_by_tag": {
              "terms": { "field": 'tags.keyword' }
            }
          }
        }
      )
    end

    def by_categories_menu
      client = Elasticsearch::Client.new Rails.application.config.elastic
      client.search(
        index: Elastic::IndexName.posts,
        body: {
          "size": 1_000,
          "aggs": {
            "group_by_post_category_title": {
              "terms": { "field": 'post_category_title.keyword' }
            }
          }
        }
      )
    end

    def set_settings
      @settings = { singular: :help,
                    plural: :help,
                    model_class: Help,
                    form_class: Columns::HelpForm,
                    query_class: HelpSearchQuery,
                    decorator_class: HelpDecorator }
    end

    def system_default_workspace
      url_for(**workspace_params,
              per: @pagination_rule.per,
              sort: :priority,
              order: :desc)
    end
  end
end
