# frozen_string_literal: true

require 'sidekiq/web.rb'

# Sidekiq::Web.set :session_secret, Rails.application.secrets[:secret_token]
# Sidekiq::Web.set :session_secret, Rails.application.secrets.secret_key_base
# Sidekiq::Web.set :sessions, Rails.application.config.session_options
Sidekiq::Web.set :sessions, false

Sidekiq.configure_server do |config|
  config.redis = Rails.configuration.redis
end

Sidekiq.configure_client do |config|
  config.redis = Rails.configuration.redis
end
