class Settings::AvatarsController < ApplicationController
  layout 'dashboard'

  def update
    current_user.avatar.attach(params[:file])
  end
end
