Sidekiq.configure_server do |config|
  config.redis = Rails.configuration.redis_sidekiq
end

Sidekiq.configure_client do |config|
  config.redis = Rails.configuration.redis_sidekiq
end
