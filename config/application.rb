# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
require 'view_component/engine'

module Hub
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    config.redis = config_for(:redis)
    config.elastic = config_for(:elastic)
    config.global = config_for(:global)

    config.oauth_providers = %w[facebook google_oauth2].freeze
    config.action_mailer.default_url_options = { host: ENV['DOMAIN_NAME'], protocol: 'https' }

    config.action_cable.allowed_request_origins = [
      "https://#{ENV['DOMAIN_NAME']}",
      %r{https://.*\.#{Regexp.quote(ENV['DOMAIN_NAME'])}}
    ]

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # # TODO: security? limit hosts?
    # config.to_prepare do
    #   ActionText::ContentHelper.allowed_tags << "iframe"
    # end
  end
end
