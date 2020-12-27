# frozen_string_literal: true

module Tables
  class PostsController < ApplicationController
    ALLOWED_PARAMS = %i[q per page sort order cols dwf dcf].freeze
    REQUIRED_PARAMS = %i[per order sort cols].freeze

    include Workspaceable
    include Tableable
    layout 'backoffice'

    # GET /posts
    def index
      get_index(['currency'],  filter_ids: (current_user.id if current_user.role == 'user'))
    end

    def set_settings
      @settings = { singular: :post,
                    plural: :posts,
                    model_class: Post,
                    form_class: Columns::PostForm,
                    query_class: PostsSearchQuery,
                    decorator_class: PostDecorator }
    end

    def system_default_workspace
      url_for(**workspace_params,
              cols: @settings[:form_class].default_stringified_columns_for(request),
              per: @pagination_rule.per,
              sort: :id,
              order: :desc)
    end

    def set_preserved_search_params
      @preserved_search_params = %i[order per sort q dwf]
    end
  end
end
