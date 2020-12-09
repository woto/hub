# frozen_string_literal: true

class Tables::ChecksController < ApplicationController
  ALLOWED_PARAMS = [:q, :per, :page, :sort, :order, :cols]
  REQUIRED_PARAMS = [:per, :cols]

  include Workspaceable
  include Tableable
  layout 'backoffice'
  before_action :set_check, only: %i[show edit update destroy]

  def index
    get_index(['currency'], (current_user.id if current_user.role == 'user'))
  end

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

  def set_settings
    @settings = { singular: :check,
                  plural: :checks,
                  model_class: Check,
                  form_class: Columns::CheckForm,
                  query_class: ChecksSearchQuery,
                  decorator_class: CheckDecorator
    }
  end

  def system_default_workspace
    url_for(**workspace_params,
            cols: @settings[:form_class].default_stringified_columns_for(request),
            per: @pagination_rule.per,
            sort: :id,
            order: :desc)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_check
    @check = Check.find(params[:id])
  end

  def check_params
    params.require(:check).permit(:amount, :currency, :is_payed, :payed_at)
  end
end
