# frozen_string_literal: true

module Api
  module V1
    module Staff
      module Seeder
        # Used to seed postgres for puppeteer tests
        class RedisController < Api::V1::Staff::BaseController
          def get_ready_for_proxy
            key = SecureRandom.hex
            auth = Faker::Omniauth.google
            redis = Redis.new(Rails.configuration.redis_oauth)
            redis.set(key, auth.to_json)
            respond_with key
          end
        end
      end
    end
  end
end
