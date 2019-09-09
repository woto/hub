# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::Users::BindsController, type: :request do
  def make
    patch "/api/v1/users/binds/#{key}"
  end

  let(:key) { SecureRandom.hex }
  let(:auth) { Faker::Omniauth.linkedin }
  let!(:user) { create(:user, email: auth['info']['email']) }
  let!(:identity) { create(:identity, user: user) }

  before do
    redis = Redis.new(Rails.configuration.redis_oauth)
    redis.set(key, auth.to_json)
  end

  context 'when another identity present' do
    it { expect(identity.user).to eq user }

    it 'returns access_token' do
      make
      expect(JSON.parse(response.body)).to have_key('access_token')
    end

    it 'creates new identity' do
      expect { make }.to change(Identity, :count).from(1).to(2)
    end

    it 'binds new identity' do
      make
      expect(Identity.last.user).to eq user
    end

    it { expect(user).to be_confirmed }

    it "doesn't create new user" do
      expect { make }.not_to change(User, :count)
    end
  end
end