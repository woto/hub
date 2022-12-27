# frozen_string_literal: true

REDIS = Redis.new(Rails.configuration.redis_cache)
