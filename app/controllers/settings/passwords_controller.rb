# frozen_string_literal: true

class Settings::PasswordsController < Users::RegistrationsController
  layout 'backoffice'

  private

  # TODO: is this criminal? I want to give ability to change password without current_password.
  def update_resource(resource, params)
    resource.define_singleton_method(:valid_password?) do |_|
      true
    end
    super
  end
end
