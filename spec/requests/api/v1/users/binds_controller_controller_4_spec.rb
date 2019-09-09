# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::Users::BindsController, type: :request do
  def make
    patch "/api/v1/users/binds/#{key}"
  end

  let(:key) { SecureRandom.hex }
  let(:auth) { identity.auth }
  let(:user) { identity.user }
  let!(:identity) { create(:identity, :with_user) }

  before do
    redis = Redis.new(Rails.configuration.redis_oauth)
    redis.set(key, auth.to_json)
  end

  context 'when this identity present' do
    it { expect(user).to be_confirmed }

    it 'returns access_token' do
      make
      expect(JSON.parse(response.body)).to have_key('access_token')
    end

    it "doesn't create new identity" do
      expect { make }.not_to change(Identity, :count)
    end

    it "doesn't create new user" do
      expect { make }.not_to change(User, :count)
    end
  end
end
