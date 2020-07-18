# frozen_string_literal: true

require 'oauth2'

module Ext
  module Admitad
    module Api
      module Token
        class Restore
          include ApplicationInteractor

          def call
            Rails.logger.debug("Ext::Admitad::Api::Token::Restore")
            token = Rails.cache.read(TOKEN_KEY)
            context.fail! unless token
            Rails.logger.debug("Found token #{token}")

            context.token = token
          end
        end
      end
    end
  end
end
