# frozen_string_literal: true

require 'rails_helper'

describe IndexNowController do
  it 'returns correct response' do
    get index_now_path
    expect(response).to have_http_status(:ok)
    expect(response.body).to eq('index_now_key_value')
  end
end
