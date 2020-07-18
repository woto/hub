# frozen_string_literal: true

require 'oauth2'

module Ext
  module Admitad
    module Api
      module Token
        class Retrive
          include Interactor

          def call
            Rails.logger.debug("Ext::Admitad::Api::Token::Retrive")
            client = OAuth2::Client.new(ENV['ADMITAD_ID'],
                                        ENV['ADMITAD_SECRET'],
                                        site: 'https://api.admitad.com',
                                        token_url: '/token/')
            base64 = Base64.strict_encode64("#{ENV['ADMITAD_ID']}:#{ENV['ADMITAD_SECRET']}")
            token = client.client_credentials.get_token(
              scope: 'advcampaigns_for_website public_data',
              headers: { Authorization: "Basic #{base64}" }
            ).token
            Rails.logger.debug("Received new token #{token}")
            Rails.cache.write(TOKEN_KEY, token, expires_in: 5.days)
            context.token = token
          end
        end
      end
    end
  end
end
