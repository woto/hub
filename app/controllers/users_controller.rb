class UsersController < ApplicationController
  layout 'backoffice'
  before_action :set_user, only: %i[show edit update destroy impersonate]

  # TODO: authorize
  def impersonate
    impersonate_user(@user)
    redirect_to root_path
  end

  # TODO: authorize
  def stop_impersonating
    stop_impersonating_user
    redirect_to root_path
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

end
