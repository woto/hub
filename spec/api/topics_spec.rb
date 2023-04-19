# frozen_string_literal: true

require 'rails_helper'
require_relative '../support/shrine_image'

describe API::Mentions, type: :request, responsible: :admin do
  let!(:user) { create(:user) }

  context 'when search string is present' do
    describe 'GET /api/topics' do
      let!(:mention) do
        create(:mention, topics: [create(:topic, title: 'first'), create(:topic, title: 'second')])
        create(:mention, topics: [create(:topic, title: 'third')])
      end

      it 'autocompletes mentions by topics' do
        get '/api/topics', headers: { 'HTTP_API_KEY' => user.api_key }, params: { q: 'secon' }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to match([{ 'count' => nil, 'id' => 2, 'title' => 'second' }])
      end
    end
  end

  context 'when search sting is absent' do
    pending
  end
end
