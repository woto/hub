# frozen_string_literal: true

module Tables
  class PostsController < ApplicationController
    ALLOWED_PARAMS = %i[q per page sort order cols].freeze
    REQUIRED_PARAMS = %i[per order sort cols].freeze

    include Workspaceable
    include Tableable
    layout 'backoffice'

    # GET /posts
    def index
      get_index(['currency'], filter_ids: (current_user.id unless current_user.staff?))
    end

    def set_settings
      @settings = { singular: :post,
                    plural: :posts,
                    model_class: Post,
                    form_class: Columns::PostForm,
                    query_class: PostsSearchQuery,
                    decorator_class: PostDecorator,
                    favorites_kind: :posts,
                    favorites_items_kind: :posts
      }
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
