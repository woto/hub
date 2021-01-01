# frozen_string_literal: true

module Tables
  class TransactionsController < ApplicationController
    ALLOWED_PARAMS = %i[q per page sort order cols].freeze
    REQUIRED_PARAMS = %i[per order sort cols].freeze

    include Workspaceable
    include Tableable
    layout 'backoffice'
    skip_before_action :authenticate_user!

    # GET /transactions
    def index
      get_index(['currency'], filter_ids: (current_user.account_ids if current_user.role == 'user'))
    end

    private

    def set_settings
      @settings = { singular: :transaction,
                    plural: :transactions,
                    model_class: Transaction,
                    form_class: Columns::TransactionForm,
                    query_class: TransactionsSearchQuery,
                    decorator_class: TransactionDecorator }
    end

    def system_default_workspace
      url_for(**workspace_params,
              cols: @settings[:form_class].default_stringified_columns_for(request),
              per: @pagination_rule.per,
              sort: :id,
              order: :desc)
    end

    def set_preserved_search_params
      @preserved_search_params = %i[order per sort q]
    end
  end
end
