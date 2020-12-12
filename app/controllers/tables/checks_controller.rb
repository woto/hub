# frozen_string_literal: true

module Tables
  class ChecksController < ApplicationController
    ALLOWED_PARAMS = %i[q per page sort order cols].freeze
    REQUIRED_PARAMS = %i[per cols].freeze

    include Workspaceable
    include Tableable
    layout 'backoffice'

    # GET /checks
    def index
      get_index(['currency'], (current_user.id if current_user.role == 'user'))
    end

    private

    def set_settings
      @settings = { singular: :check,
                    plural: :checks,
                    model_class: Check,
                    form_class: Columns::CheckForm,
                    query_class: ChecksSearchQuery,
                    decorator_class: CheckDecorator }
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
