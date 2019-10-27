# frozen_string_literal: true

module Api
  module V1
    module Users
      # ConfirmationsController
      class ConfirmationsController < Devise::ConfirmationsController
        include DoorkeeperTokenable

        def show
          super do |user|
            # TODO: check confirm, unlock... i.e. all inside block
            # also have to reset confirmation_token
            if user.errors.empty?
              render(json: build_token_response(user).body) && return
            end
          end
        end
      end
    end
  end
end
