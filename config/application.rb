require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
require "rails/test_unit/railtie"

require_relative "../app/middlewares/locale"
# require 'prometheus/middleware/collector'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

require 'view_component/engine'

module Hub
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.redis = config_for(:redis)
    config.elastic = config_for(:elastic)
    config.prometheus = config_for(:prometheus)
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

    # config.middleware.use Prometheus::Middleware::Collector

    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true

    config.cache_store = :redis_cache_store, {
      url: Rails.application.config.redis.yield_self do |redis|
        "redis://#{redis[:host]}:#{redis[:port]}/#{redis[:db]}"
      end
    }

    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.to_i}"
    }

    config.middleware.insert_after(Rack::Head, ::Locale)
  end
end
