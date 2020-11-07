# frozen_string_literal: true

class TransactionsController < ApplicationController
  ALLOWED_PARAMS = [:q, :per, :page, :sort, :order, :cols]
  REQUIRED_PARAMS = [:per, :cols]

  include Workspaceable
  layout 'backoffice'
  before_action :set_transaction, only: %i[show edit update destroy]
  skip_before_action :authenticate_user!
  before_action { prepend_view_path Rails.root + 'app' + 'views/template' }
  before_action { prepend_view_path Rails.root + 'app' + 'views/table' }

  def index
    transactions = Transaction.__elasticsearch__.search(
        params[:q].presence || '*',
        _source: Columns::TransactionForm.parsed_columns_for(request),
        sort: "#{params[:sort]}:#{params[:order]}"
    ).page(@pagination_rule.page).per(@pagination_rule.per)

    favorites = Contexts::Favorites.new(current_user, transactions)
    @transactions = OfferDecorator.decorate_collection(transactions, context: { favorites: favorites })

    render 'empty_page' and return if @transactions.empty?

    @columns_form = Columns::TransactionForm.new(displayed_columns: Columns::TransactionForm.parsed_columns_for(request))
    render 'index', locals: { rows: @transactions }
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
                  form_class: Columns::TransactionForm }
  end

  def system_default_workspace
    url_for(**workspace_params,
            cols: @settings[:form_class].default_stringified_columns_for(request),
            per: @pagination_rule.per,
            sort: :id,
            order: :desc)
  end
end
