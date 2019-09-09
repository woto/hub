# frozen_string_literal: true

module DoorkeeperTokenable
  extend ActiveSupport::Concern

  included do
    def build_token_response(user)
      access_token = Doorkeeper::AccessToken.create(
        resource_owner_id: user.id,
        refresh_token: generate_refresh_token,
        expires_in: Doorkeeper.configuration.access_token_expires_in.to_i,
        scopes: ''
      )
      Doorkeeper::OAuth::TokenResponse.new(access_token)
    end

    private

    def generate_refresh_token
      loop do
        token = SecureRandom.hex(32)
        break token unless Doorkeeper::AccessToken.exists?(refresh_token: token)
      end
    end
  end
end
