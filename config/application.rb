# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# --

# require "rails"
# # Pick the frameworks you want:
# require "active_model/railtie"
# require "active_job/railtie"
# require "active_record/railtie"
# require "active_storage/engine"
# require "action_controller/railtie"
# require "action_mailer/railtie"
# require "action_view/railtie"
# require "action_cable/engine"
# # require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Hub
  class Application < Rails::Application
    config.redis_cache = config_for(:redis_cache)
    config.redis_oauth = config_for(:redis_oauth)
    config.elastic = config_for(:elastic)

    config.oauth_providers = %w[facebook github google_oauth2 instagram
                                twitter].freeze
    config.action_mailer.default_url_options = { host: 'nv6.ru', protocol: 'https' }

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    config.debug_exception_response_format = :api

    config.action_cable.allowed_request_origins = ['https://nv6.ru', %r{https://.*\.nv6.ru}]

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
