# frozen_string_literal: true

class TransactionsController < ApplicationController
  # NOTE: Seems not used. Something old
  # layout 'backoffice'
  # skip_before_action :authenticate_user!
  #
  # private
  #
  # def set_transaction
  #   @transaction = Transaction.find(params[:id])
  # end
  #
  # def transaction_params
  #   params.require(:transaction).permit(:name, :url, :advertiser_id)
  # end
end
