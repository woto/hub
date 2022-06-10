# frozen_string_literal: true

require 'rails_helper'

describe API::Me, type: :request do
  let!(:user) { create(:user) }

  describe 'GET /api/me' do
    it 'returns info about me' do
      get '/api/me', headers: { 'HTTP_API_KEY' => user.api_key }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to match(
        'id' => user.id,
        'email' => user.email,
        'created_at' => satisfying { |val| expect(Time.parse(val)).to be_within(1.second).of(user.created_at) },
        'updated_at' => satisfying { |val| expect(Time.parse(val)).to be_within(1.second).of(user.updated_at) },
        'role' => user.role,
        'posts_count' => user.posts_count,
        'checks_count' => user.checks_count,
        'favorites_count' => user.favorites_count,
        'workspaces_count' => user.workspaces_count,
        'profiles_count' => user.profiles_count,
        'identities_count' => user.identities_count,
        'api_key' => user.api_key,
        'mentions_count' => user.mentions_count,
        'entities_count' => user.entities_count,
        'log_data' => nil
      )
    end

    context 'when user is not authorized' do
      it 'returns error' do
        get '/api/me',
            headers: { 'ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json' }
        expect(JSON.parse(response.body)).to eq('error' => 'You need to sign in or sign up before continuing.')
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when API key is incorrect' do
      it 'returns error' do
        get '/api/me',
            headers: { 'API-KEY' => '123', 'ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json' }
        expect(JSON.parse(response.body)).to eq(
          'error' => 'Invalid API key. Use API-KEY header or api_key query string parameter.'
        )
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
