# frozen_string_literal: true

module Api
  module V1
    module Users
      # This class used in oauth authentication process
      class BindsController < BaseController
        include DoorkeeperTokenable
        before_action :doorkeeper_authorize!, if: -> { valid_doorkeeper_token? }
        before_action :read_oauth_info_from_redis

        def update
          user = current_user || User.new(email: @oauth.info['email'])
          bind_identity(user)
          request.env['warden'].set_user(user, store: false)
          render json: build_token_response(user).body
        end

        private

        def read_oauth_info_from_redis
          redis = Redis.new(Rails.configuration.redis_oauth)
          raw = JSON.parse(redis.get(params[:id]))
          @oauth = OauthStruct.new(raw)
        end

        # Every identity will be binded to this user.
        # Pay attention that there is can be situations with orphan users
        # (from which identity was unbinded)
        def bind_identity(user)
          identity = Identity.find_by(uid: @oauth.uid,
                                      provider: @oauth.provider)
          if identity
            identity.update!(user: user, auth: @oauth)
          else
            Identity.create!(
              uid: @oauth.uid,
              provider: @oauth.provider,
              user: user,
              auth: @oauth
            )
          end
          # user = identity.user
        end
      end
    end
  end
end
