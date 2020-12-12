# frozen_string_literal: true

module Tables
  class PostCategoriesController < ApplicationController
    ALLOWED_PARAMS = %i[q per page sort order cols].freeze
    REQUIRED_PARAMS = %i[per cols].freeze

    include Workspaceable
    include Tableable
    layout 'backoffice'
    skip_before_action :authenticate_user!

    # GET /post_categories
    def index
      get_index([], nil)
    end

    private

    def set_settings
      @settings = { singular: :post_category,
                    plural: :post_categories,
                    model_class: PostCategory,
                    form_class: Columns::PostCategoryForm,
                    query_class: PostCategoriesSearchQuery,
                    decorator_class: PostCategoryDecorator }
    end

    def system_default_workspace
      url_for(**workspace_params,
              cols: @settings[:form_class].default_stringified_columns_for(request),
              per: @pagination_rule.per,
              sort: :id,
              order: :desc)
    end
  end
end
