# frozen_string_literal: true

Rails.application.config.session_store :redis_session_store,
                                       key: 'session',
                                       redis: {
                                         expire_after: 120.minutes,  # cookie expiration
                                         ttl: 120.minutes,           # Redis expiration, defaults to 'expire_after'
                                         key_prefix: "hub_#{Rails.env}",
                                         url: Rails.application.config.redis.yield_self do |redis|
                                                "redis://#{redis[:host]}:#{redis[:port]}/#{redis[:db]}"
                                              end
                                       }
