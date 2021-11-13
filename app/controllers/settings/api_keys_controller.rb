# frozen_string_literal: true

class Settings::APIKeysController < ApplicationController
  layout 'backoffice'

  def update
    flash.now[:notice] = t('.success')
    current_user.assign_api_key!
    current_user.save!
  end
end
