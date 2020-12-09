# frozen_string_literal: true

class Tables::AccountsController < ApplicationController
  ALLOWED_PARAMS = %i[q per page sort order cols].freeze
  REQUIRED_PARAMS = %i[per cols].freeze

  include Workspaceable
  include Tableable
  layout 'backoffice'
  before_action :set_account, only: %i[show edit update destroy]
  skip_before_action :authenticate_user!

  def index
    get_index(['currency'], (current_user.id if current_user && current_user.role == 'user'))
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
                  form_class: Columns::AccountForm,
                  query_class: AccountsSearchQuery,
                  decorator_class: AccountDecorator
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
