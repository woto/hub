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

        def update
          self.resource = current_user
          prev_unconfirmed_email = resource.unconfirmed_email

          # Stupidest hack
          old_email = resource.email
          if old_email && user_params[:email] == old_email
            resource.update_columns(email: nil)
          end

          resource_updated = resource.update(user_params)

          # Stupidest hack
          if old_email && user_params[:email] == old_email
            resource.update_columns(email: user_params[:email])
          end

          if resource_updated
            # bypass_sign_in resource, scope: resource_name if sign_in_after_change_password?
          else
            clean_up_passwords resource
            respond_with resource
          end
        end

        protected

        def user_params
          params.require(:user).permit(:email, :password)
        end

        # https://github.com/doorkeeper-gem/doorkeeper/wiki/Running-Doorkeeper-with-Devise
        def authenticate_scope!
          self.resource = current_user
        end
      end
    end
  end
end
