# frozen_string_literal: true

require 'rails_helper'

describe 'shared.rb', type: :request do
  include_context 'with shared authentication'

  it do
    xpost '/api/v1/profile'
    expect(response).to have_http_status(:ok)
  end

  it do
    xpost '/api/v1/profile', headers: { 'some': 'header' }
    expect(response).to have_http_status(:ok)
  end

  it do
    xpost '/api/v1/profile', params: { 'some': 'param' }
    expect(response).to have_http_status(:ok)
  end
end
