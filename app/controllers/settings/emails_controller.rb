# frozen_string_literal: true

class Settings::EmailsController < Users::RegistrationsController
  layout 'dashboard'

  private

  def update_resource(resource, params)
    resource.update_without_password(params)
  end
end
