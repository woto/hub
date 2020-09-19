# frozen_string_literal: true

class Settings::AvatarsController < ApplicationController
  layout 'backoffice'

  def update
    current_user.avatar.attach(params[:file])
  end
end
