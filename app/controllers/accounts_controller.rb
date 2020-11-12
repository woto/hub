# frozen_string_literal: true

class AccountsController < ApplicationController
  ALLOWED_PARAMS = %i[q per page sort order cols].freeze
  REQUIRED_PARAMS = %i[per cols].freeze

  include Workspaceable
  layout 'backoffice'
  before_action :set_account, only: %i[show edit update destroy]
  skip_before_action :authenticate_user!
  before_action { prepend_view_path Rails.root + 'app' + 'views/template' }
  before_action { prepend_view_path Rails.root + 'app' + 'views/table' }

  def index
    accounts = Account.__elasticsearch__.search(
      params[:q].presence || '*',
      _source: Columns::AccountForm.parsed_columns_for(request),
      sort: "#{params[:sort]}:#{params[:order]}"
    ).page(@pagination_rule.page).per(@pagination_rule.per)

    favorites = Contexts::Favorites.new(current_user, accounts)
    @accounts = OfferDecorator.decorate_collection(accounts, context: { favorites: favorites })

    render 'empty_page' and return if @accounts.empty?

    @columns_form = Columns::AccountForm.new(displayed_columns: Columns::AccountForm.parsed_columns_for(request))
    render 'index', locals: { rows: @accounts }
  end

  private

  def set_account
    @account = Account.find(params[:id])
  end

  def account_params
    params.require(:account).permit(:name, :url, :advertiser_id)
  end

  def set_settings
    @settings = { singular: :account,
                  plural: :accounts,
                  model_class: Account,
                  form_class: Columns::AccountForm }
  end

  def system_default_workspace
    url_for(**workspace_params,
            cols: @settings[:form_class].default_stringified_columns_for(request),
            per: @pagination_rule.per,
            sort: :id,
            order: :desc)
  end
end
