# frozen_string_literal: true

module Tables
  class NewsController < ApplicationController
    ALLOWED_PARAMS = %i[q per page sort order].freeze
    REQUIRED_PARAMS = [:per].freeze

    include Workspaceable
    include Tableable
    layout 'backoffice'
    skip_before_action :authenticate_user!

    # GET /news
    def index
      get_index([], nil)
    end

    private

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
