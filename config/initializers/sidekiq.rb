# frozen_string_literal: true

require 'sidekiq/web.rb'

# Sidekiq::Web.set :session_secret, Rails.application.secrets[:secret_token]
# Sidekiq::Web.set :session_secret, Rails.application.secrets.secret_key_base
# Sidekiq::Web.set :sessions, Rails.application.config.session_options
# Sidekiq::Web.set :sessions, false

Sidekiq.configure_server do |config|
  # config.log_formatter = Sidekiq::Logger::Formatters::JSON.new
  config.redis = Rails.configuration.redis_sidekiq
  Yabeda::Prometheus::Exporter.start_metrics_server!
end

Sidekiq.configure_client do |config|
  config.redis = Rails.configuration.redis_sidekiq
end

# https://github.com/woto/sidekiq_backtrace/commit/b40efadc14013ffc5607ecc4c2d25c1c988fe061#diff-ae13acc8819c30684b141a36c3994f78d0cef31e9a029931f472009f1d0b79bd
# NOTE: commented out after updating gems
# Sidekiq.default_worker_options = { 'backtrace' => true }
