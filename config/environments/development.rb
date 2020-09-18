# frozen_string_literal: true
require 'rack/reverse_proxy'

Rails.application.configure do
  config.web_console.allowed_ips = %w[0.0.0.0/0 ::/0]
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  if Rails.root.join('tmp', 'caching-dev.txt').exist?
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
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Store uploaded files on the local file system (see config/storage.yml for options).
  config.active_storage.service = :local

  # Mount Action Cable outside main process or domain
  config.action_cable.mount_path = '/cable'
  # config.action_cable.url = 'wss://example.com/cable'

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true

  # Raises error for missing translations.
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  config.hosts = nil

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address: ENV['MAILCATCHER_HOST'],
    port: ENV['MAILCATCHER_SMTP_PORT']
  }

  config.action_mailer.preview_path = "#{Rails.root}/spec/mailers/previews"

  config.force_ssl = true if ActiveModel::Type::Boolean.new.cast(ENV.fetch('SSL_DEBUG'))

  config.middleware.insert(0, Rack::ReverseProxy) do
    reverse_proxy_options preserve_host: true
    reverse_proxy '/thumbnail', 'http://localhost:9700/'
  end

  config.active_job.queue_adapter = :sidekiq
end
