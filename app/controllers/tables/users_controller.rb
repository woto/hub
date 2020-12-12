# frozen_string_literal: true

# frozen_string_literal: true

module Tables
  class UsersController < ApplicationController
    ALLOWED_PARAMS = %i[q per page sort order cols].freeze
    REQUIRED_PARAMS = %i[per cols].freeze

    include Workspaceable
    include Tableable
    layout 'backoffice'

    def index
      get_index([], (current_user.id if current_user.role == 'user'))
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
  end
end
