# frozen_string_literal: true

require 'oauth2'

module Ext
  module Admitad
    module Api
      module Token
        class Restore
          include Interactor

          def call
            token = Rails.cache.read(TOKEN_KEY)
            Rails.logger.debug(token)
            context.fail!(message: "Admitad cached token not found") if token.nil?

            context.token = token
          end
        end
      end
    end
  end
end
