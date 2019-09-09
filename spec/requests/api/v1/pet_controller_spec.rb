# frozen_string_literal: true

require 'spec_helper'

describe Api::V1::PetController, type: :request do
  def make
    post '/api/v1/pet', params: { access_token: token.token }
  end

  let!(:token) { create(:oauth_access_tokens) }

  it do
    make
    expect(response).to have_http_status(:ok)
  end
end
