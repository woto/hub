# frozen_string_literal: true

module Tables
  class AccountsController < ApplicationController
    ALLOWED_PARAMS = %i[q per page sort order cols].freeze
    REQUIRED_PARAMS = %i[per cols].freeze

    include Workspaceable
    include Tableable
    layout 'backoffice'
    skip_before_action :authenticate_user!

    # GET /accounts
    def index
      get_index(['currency'], (current_user.id if current_user && current_user.role == 'user'))
    end

    private

    def set_settings
      @settings = { singular: :account,
                    plural: :accounts,
                    model_class: Account,
                    form_class: Columns::AccountForm,
                    query_class: AccountsSearchQuery,
                    decorator_class: AccountDecorator }
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
