# frozen_string_literal: true

# frozen_string_literal: true

module Tables
  class UsersController < ApplicationController
    ALLOWED_PARAMS = %i[q per page sort order cols dwf dcf].freeze
    REQUIRED_PARAMS = %i[per order sort cols].freeze

    include Workspaceable
    include Tableable
    layout 'backoffice'

    def index
      get_index([], filter_ids: (current_user.id if current_user.role == 'user'))
    end

    private

    def set_settings
      @settings = { singular: :user,
                    plural: :users,
                    model_class: User,
                    form_class: Columns::UserForm,
                    query_class: UsersSearchQuery,
                    decorator_class: UserDecorator }
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
