# frozen_string_literal: true

class UsersController < ApplicationController
  ALLOWED_PARAMS = [:q, :per, :page, :sort, :order, :cols]
  REQUIRED_PARAMS = [:per, :cols]

  include Workspaceable
  layout 'backoffice'
  before_action :set_user, only: %i[show edit update destroy impersonate]
  before_action { prepend_view_path Rails.root + 'app' + 'views/template' }
  before_action { prepend_view_path Rails.root + 'app' + 'views/table' }

  def index
    @users = User.__elasticsearch__.search(
        params[:q].presence || '*',
        _source: Columns::UserForm.parsed_columns_for(request),
        sort: "#{params[:sort]}:#{params[:order]}"
    ).page(@pagination_rule.page).per(@pagination_rule.per)

    render 'empty_page' and return if @users.empty?

    @columns_form = Columns::UserForm.new(displayed_columns: Columns::UserForm.parsed_columns_for(request))
    render 'index', locals: { rows: @users }
  end

  def impersonate
    impersonate_user(@user)
    redirect_to root_path
  end

  def stop_impersonating
    stop_impersonating_user
    redirect_to root_path
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def set_settings
    @settings = { singular: :user,
                  plural: :users,
                  model_class: User,
                  form_class: Columns::UserForm }
  end

  def set_pagination_rule
    @pagination_rule = PaginationRules.new(request)
  end

  def redirect_with_defaults
    redirect_to url_for(**workspace_params,
                        cols: @settings[:form_class].default_stringified_columns_for(request),
                        per: @pagination_rule.per)
  end
end
