# frozen_string_literal: true

module Tables
  class TransactionsController < ApplicationController
    ALLOWED_PARAMS = [:q, :per, :page, :sort, :order, { filters: {} }, { columns: [] }].freeze
    REQUIRED_PARAMS = %i[per order sort columns].freeze

    include Workspaceable
    include Tableable
    layout 'backoffice'

    # GET /transactions
    def index
      get_index(%w[id currency debit_id credit_id amount],
                filter_ids: (current_user.account_ids if current_user.role == 'user'))
    end

    # TODO: action?!
    def workspace
      OpenStruct.new(
        **workspace_params,
        columns: @settings[:form_class]::DEFAULTS,
        per: @pagination_rule.per,
        sort: 'id',
        order: 'desc'
      )
    end

    private

    def set_settings
      @settings = GlobalHelper.class_configurator('transaction')
    end
  end
end
