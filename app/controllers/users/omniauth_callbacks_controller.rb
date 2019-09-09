# frozen_string_literal: true

module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    # https://github.com/plataformatec/devise/wiki/OmniAuth:-Overview

    def callback
      key = SecureRandom.hex
      auth = request.env['omniauth.auth']
      redis = Redis.new(Rails.configuration.redis_oauth)
      redis.set(key, auth.to_json)
      redirect_to "/users/proxy/#{key}"
    end
  end
end