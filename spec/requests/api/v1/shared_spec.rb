# frozen_string_literal: true

require 'rails_helper'

describe 'shared.rb', type: :request, include_shared: true do
  it do
    xpost '/api/v1/pet'
    expect(response).to have_http_status(:ok)
  end

  it do
    xpost '/api/v1/pet', headers: { 'some': 'header' }
    expect(response).to have_http_status(:ok)
  end

  it do
    xpost '/api/v1/pet', params: { 'some': 'param' }
    expect(response).to have_http_status(:ok)
  end
end
