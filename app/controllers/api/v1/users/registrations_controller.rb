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
          # Start of "copy paste" from devise gem
          self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
          prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)
          # till here

          # Stupidest hack
          old_email = resource.email
          if old_email && account_update_params[:email] == old_email
            resource.update_columns(email: nil)
          end

          # Start of "copy paste" from devise gem
          resource_updated = update_resource(resource, account_update_params)
          # till here

          # Stupidest hack
          if old_email && account_update_params[:email] == old_email
            resource.update_columns(account_update_params)
          end

          # Start of "copy paste" from devise gem
          yield resource if block_given?
          if resource_updated
            set_flash_message_for_update(resource, prev_unconfirmed_email)
            bypass_sign_in resource, scope: resource_name if sign_in_after_change_password?

            respond_with resource, location: after_update_path_for(resource)
          else
            clean_up_passwords resource
            set_minimum_password_length
            respond_with resource
          end
          # till here
        end

        # Override requiring password to change e-mail
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
