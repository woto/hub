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
          user = bind_identity
          request.env['warden'].set_user(user, store: false)
          render json: build_token_response(user).body
        end

        private

        def read_oauth_info_from_redis
          redis = Redis.new(Rails.configuration.redis_oauth)
          str = redis.get(params[:id])
          return head(:gone) if str.nil?

          redis.del(params[:id])
          json = JSON.parse(str)
          @oauth = OauthStruct.new(json)
        end

        # Every identity will be binded to this user.
        # Pay attention that there is can be situations with orphan users
        # (from which identity was unbinded)
        def bind_identity
          identity = Identity.find_by(uid: @oauth.uid,
                                      provider: @oauth.provider)
          user = current_user || identity&.user || User.new(oauthenticable: true)
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
          user
        end
      end
    end
  end
end
