# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController

  protected

  # https://github.com/doorkeeper-gem/doorkeeper/wiki/Running-Doorkeeper-with-Devise
  def authenticate_scope!
    self.resource = send(:"current_#{resource_name}")
  end

end
