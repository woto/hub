# frozen_string_literal: true

class ChecksController < ApplicationController
  layout 'backoffice'
  before_action :set_check, only: %i[show edit update destroy]

  # GET /checks/:id
  def show
    authorize(@check)
  end

  # GET /checks/new
  def new
    @check = current_user.checks.new
    authorize(@check)
  end

  # GET /checks/:id/edit
  def edit
    authorize(@check)
  end

  # POST /checks
  def create
    GlobalHelper.retryable do
      @check = policy_scope(Check).new(permitted_attributes(Check))
      authorize(@check)
      if @check.save
        redirect_to @check, notice: t('.check_was_successfully_created')
      else
        render :new, status: :unprocessable_entity
      end
    end
  end

  # PATCH/PUT /checks/:id
  def update
    GlobalHelper.retryable do
      authorize(@check)
      if @check.update(permitted_attributes(Check))
        redirect_to @check, notice: t('.check_was_successfully_updated')
      else
        render :edit, status: :unprocessable_entity
      end
    end
  end

  # DELETE /checks/:id
  def destroy
    GlobalHelper.retryable do
      authorize(@check)
      redirect_to checks_url, notice: t('.check_was_successfully_destroyed') if @check.update(status: :removed_check)
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_check
    @check = policy_scope(Check).find(params[:id])
  end
end
