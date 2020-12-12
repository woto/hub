# frozen_string_literal: true

class ChecksController < ApplicationController
  layout 'backoffice'
  before_action :set_check, only: %i[show edit update destroy]
  
  def new
    @check = Check.new
  end

  def create
    GlobalHelper.retryable do
      @check = policy_scope(Check).new(check_params)
      authorize(@check)
      if @check.save
        redirect_to @check, notice: 'Check was successfully created.'
      else
        render :new
      end
    end
  end

  def update
    GlobalHelper.retryable do
      authorize(@check)
      if @check.update(check_params)
        redirect_to @check, notice: 'Check was successfully updated.'
      else
        render :edit
      end
    end
  end

  def show
    respond_to do |format|
      format.json { render json: @feed }
      format.html
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_check
    @check = Check.find(params[:id])
  end

  def check_params
    params.require(:check).permit(:amount, :currency, :is_payed, :payed_at)
  end
end
