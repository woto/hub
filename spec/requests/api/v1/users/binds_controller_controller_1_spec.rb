# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::Users::BindsController, type: :request do
  def make
    patch "/api/v1/users/binds/#{key}"
  end

  let(:key) { SecureRandom.hex }
  let(:auth) { Faker::Omniauth.linkedin }


  before do
    redis = Redis.new(Rails.configuration.redis_oauth)
    redis.set(key, auth.to_json)
  end

  context 'when user with this email absent' do
    it 'returns access_token' do
      make
      expect(JSON.parse(response.body)).to have_key('access_token')
    end

    it 'confirms user' do
      make
      expect(User.last).to be_confirmed
    end

    it 'creates new identity' do
      expect { make }.to change(Identity, :count).by(1)
    end

    it 'binds new identity' do
      make
      expect(Identity.last.user).to eq User.last
    end

    it 'registers user' do
      expect { make }.to change(User, :count).by(1)
    end
  end
end
