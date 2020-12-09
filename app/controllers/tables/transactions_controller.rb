# frozen_string_literal: true

class Tables::TransactionsController < ApplicationController
  ALLOWED_PARAMS = [:q, :per, :page, :sort, :order, :cols]
  REQUIRED_PARAMS = [:per, :cols]

  include Workspaceable
  include Tableable
  layout 'backoffice'
  before_action :set_transaction, only: %i[show edit update destroy]
  skip_before_action :authenticate_user!

  def index
    get_index(['currency'], (current_user.account_ids if current_user.role == 'user'))
  end

  private

  def set_transaction
    @transaction = Transaction.find(params[:id])
  end

  def transaction_params
    params.require(:transaction).permit(:name, :url, :advertiser_id)
  end

  def set_settings
    @settings = { singular: :transaction,
                  plural: :transactions,
                  model_class: Transaction,
                  form_class: Columns::TransactionForm,
                  query_class: TransactionsSearchQuery,
                  decorator_class: TransactionDecorator
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
