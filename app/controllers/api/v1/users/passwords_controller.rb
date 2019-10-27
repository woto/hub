# frozen_string_literal: true

module Api
  module V1
    module Users
      # PasswordsController
      class PasswordsController < Devise::PasswordsController
        include DoorkeeperTokenable

        def update
          super do
            if resource.errors.empty?
              # FIXME: unlock, confirm etc...
              render(json: build_token_response(resource).body) && return
            end
          end
        end
      end
    end
  end
end
