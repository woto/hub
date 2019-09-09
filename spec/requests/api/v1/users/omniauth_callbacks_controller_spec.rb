# frozen_string_literal: true

require 'spec_helper'

describe Users::OmniauthCallbacksController, type: :request do
  OmniAuth.config.test_mode = true

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

      it 'redirects to react bind page' do
        expect(response).to redirect_to("/users/proxy/#{key}")
      end
    end
  end
end
