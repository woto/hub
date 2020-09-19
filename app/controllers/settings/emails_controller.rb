# frozen_string_literal: true

class Settings::EmailsController < Users::RegistrationsController
  layout 'backoffice'

  private

  def update_resource(resource, params)
    resource.update_without_password(params)
  end
end
