# frozen_string_literal: true

require 'spec_helper'

describe Users::OmniauthCallbacksController, type: :request do
  # Not sure if this needed (save and restore test_mode)
  # for now will be think that yes

  before(:all) do
    @initial_test_mode = OmniAuth.config.test_mode
    OmniAuth.config.test_mode = true
  end

  after(:all) do
    OmniAuth.config.test_mode = @initial_test_mode
  end

  Rails.configuration.oauth_providers.each do |provider|
    it "redirects to appropriate provider url when requesting /users/auth/#{provider}" do
      get "/users/auth/#{provider}"
      expect(response).to redirect_to("http://www.example.com/users/auth/#{provider}/callback")
    end

    describe "when requesting /users/auth/#{provider}/callback" do
      before do
        get "/users/auth/#{provider}/callback"
      end

      let(:redis) { Redis.new(Rails.configuration.redis_oauth) }
      let(:key) { response.location.split('/').last }
      let(:identity) { JSON.parse(redis.get(key)) }

      it 'stores data in redis_oauth' do
        expect(identity).to include('provider' => 'default', 'uid' => '1234',
                                    'info' => { 'name' => 'Example User' })
      end

      xit 'redirects to react bind page' do
        expect(response).to redirect_to(user_proxy_path(token: key))
      end
    end
  end
end
