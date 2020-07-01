# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Hub
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    config.paths['config/routes.rb'] = Dir[Rails.root.join('config/routes/*.rb')]

    config.redis_cache = config_for(:redis_cache)
    config.redis_oauth = config_for(:redis_oauth)
    config.redis_sidekiq = config_for(:redis_sidekiq)

    config.oauth_providers = %w[facebook github google_oauth2 instagram
                                twitter].freeze
    config.action_mailer.default_url_options = { host: ENV['DOMAIN_NAME'], protocol: 'https' }

    config.debug_exception_response_format = :api

    config.action_cable.allowed_request_origins = [
      "https://#{ENV['DOMAIN_NAME']}",
      %r{https://.*\.#{Regexp.quote(ENV['DOMAIN_NAME'])}}
    ]

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
