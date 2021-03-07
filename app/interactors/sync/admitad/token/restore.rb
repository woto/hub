# frozen_string_literal: true

require 'oauth2'

module Sync
  module Admitad
    module Token
      class Restore
        include ApplicationInteractor

        def call
          token = Rails.cache.read(TOKEN_KEY)
          context.fail! unless token
          Rails.logger.debug("Found token #{token}")

          context.token = token
        end
      end
    end
  end
end
