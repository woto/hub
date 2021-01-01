# frozen_string_literal: true

module Tables
  class HelpController < ApplicationController
    ALLOWED_PARAMS = %i[q per page sort order].freeze
    REQUIRED_PARAMS = %i[per order sort].freeze

    include Workspaceable
    include Tableable
    layout 'backoffice'
    skip_before_action :authenticate_user!

    helper_method :by_categories_menu

    def index
      # TODO
      # get_index([], nil)
    end

    def show
      @help = Post.find(params[:id])
    end

    private

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

    def set_preserved_search_params
      @preserved_search_params = %i[order per sort q]
    end
  end
end
