# frozen_string_literal: true

class AccountsController < ApplicationController
  layout 'backoffice'
  before_action :set_account, only: %i[show edit update destroy]
  skip_before_action :authenticate_user!

  private

  def set_account
    @account = Account.find(params[:id])
  end

  def account_params
    params.require(:account).permit(:name, :url, :advertiser_id)
  end
end
