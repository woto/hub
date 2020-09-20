# frozen_string_literal: true

require_relative 'boot'
require 'rails'

%w[
  active_record/railtie
  active_storage/engine
  action_controller/railtie
  action_view/railtie
  action_mailer/railtie
  active_job/railtie
  action_cable/engine
  action_mailbox/engine
  action_text/engine
  rails/test_unit/railtie
].each do |railtie|
  require railtie
rescue LoadError
end

require 'prometheus/middleware/collector'
require 'prometheus/middleware/exporter'
require 'prometheus/client/data_stores/direct_file_store'

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

    # yabeda
    Prometheus::Client.config.data_store = Prometheus::Client::DataStores::DirectFileStore.new(dir: 'tmp/prometheus')
    # config.middleware.use Prometheus::Middleware::Collector
    # config.middleware.use Prometheus::Middleware::Exporter

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
  end
end
