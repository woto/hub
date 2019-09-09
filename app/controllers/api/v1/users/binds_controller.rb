# frozen_string_literal: true

class Api::V1::Users::BindsController < ApplicationController
  include DoorkeeperTokenable
  respond_to :json

  before_action do
    @redis = Redis.new(Rails.configuration.redis_oauth)
    @auth = JSON.parse(@redis.get(params[:id]))
    @uid = @auth['uid']
    @provider = @auth['provider']
    @email = @auth['info']['email']
    @user = User.find_by(email: @email)
  end

  def update
    if current_user
      bind_new_provider
    else
      login_or_register
    end
  end

  private

  def bind_new_provider
    raise 'not implemented'
  end

  def login_or_register
    @user ||= User.create_user_for_oauth(@email)
    @user.skip_confirmation!
    @user.save!
    Identity.create_with(auth: @auth, user: @user)
            .find_or_create_by!(uid: @uid, provider: @provider)
    request.env['warden'].set_user(@user, store: false)
    render json: build_token_response(@user).body
  end
end
