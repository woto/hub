# frozen_string_literal: true

class Tables::UsersController < ApplicationController
  ALLOWED_PARAMS = [:q, :per, :page, :sort, :order, :cols]
  REQUIRED_PARAMS = [:per, :cols]

  include Workspaceable
  include Tableable
  layout 'backoffice'
  before_action :set_user, only: %i[show edit update destroy impersonate]

  def index
    get_index([], (current_user.id if current_user.role == 'user'))
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
                  form_class: Columns::UserForm,
                  query_class: UsersSearchQuery,
                  decorator_class: UserDecorator
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
