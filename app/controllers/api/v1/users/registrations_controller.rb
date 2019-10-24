# frozen_string_literal: true

module Api
  module V1
    module Users
      # Registrations
      class RegistrationsController < Devise::RegistrationsController
        include DoorkeeperTokenable

        def create
          # copied from confirmation controller
          super do |user|
            # TODO: check confirm, unlock... i.e. all inside block
            # also have to reset confirmation_token
            if user.persisted?
              render(json: build_token_response(user).body) && return
            end
          end
        end

        def update_resource(resource, params)
          resource.update(params)
        end

        protected

        # https://github.com/doorkeeper-gem/doorkeeper/wiki/Running-Doorkeeper-with-Devise
        def authenticate_scope!
          self.resource = send(:"current_#{resource_name}")
        end
      end
    end
  end
end
