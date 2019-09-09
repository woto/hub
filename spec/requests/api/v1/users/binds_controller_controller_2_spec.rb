# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::Users::BindsController, type: :request do
  def make
    patch "/api/v1/users/binds/#{key}"
  end

  let(:key) { SecureRandom.hex }
  let(:auth) { Faker::Omniauth.linkedin }
  let!(:user) { create(:user, :unconfirmed, email: auth['info']['email']) }

  before do
    redis = Redis.new(Rails.configuration.redis_oauth)
    redis.set(key, auth.to_json)
  end

  context 'when user with this email present' do
    it 'returns access_token' do
      make
      expect(JSON.parse(response.body)).to have_key('access_token')
    end

    it 'confirms user' do
      make
      expect(user.reload).to be_confirmed
    end

    it 'creates new identity' do
      expect { make }.to change(Identity, :count).by(1)
    end

    it 'binds new identity' do
      make
      expect(Identity.last.user).to eq user
    end

    it { expect(user.reload).not_to be_confirmed }

    it "doesn't create new user" do
      expect { make }.not_to change(User, :count)
    end
  end
end