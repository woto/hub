# frozen_string_literal: true

require 'oauth2'

module Networks::Admitad::Token
  class Retrieve
    include ApplicationInteractor

    def call
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
