# frozen_string_literal: true

require 'rails_helper'

describe 'shared.rb', type: :request do
  include_context 'with shared authentication'

  xit do
    xget '/api/v1/users'
    expect(response).to have_http_status(:ok)
  end

  xit do
    xget '/api/v1/users', headers: { 'some': 'header' }
    expect(response).to have_http_status(:ok)
  end

  xit do
    xget '/api/v1/users', params: { 'some': 'param' }
    expect(response).to have_http_status(:ok)
  end
end
