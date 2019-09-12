# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::PetController, type: :request do
  let!(:token) { create(:oauth_access_tokens) }

  context 'when authenticates with params' do
    def make
      post '/api/v1/pet', params: { access_token: token.token }
    end

    it do
      make
      expect(response).to have_http_status(:ok)
    end
  end

  context 'when authenticates with headers' do
    def make
      headers = {
        'Authorization' => "Bearer #{token.token}"
      }
      post '/api/v1/pet', headers: headers
    end

    it 'authenticates with headers' do
      make
      expect(response).to have_http_status(:ok)
    end
  end
end
