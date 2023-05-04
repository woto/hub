# frozen_string_literal: true

require 'rails_helper'

describe API::Cites, type: :request do
  let!(:user) { create(:user) }

  context 'minimal parameters test' do
    it 'creates cite' do
      post '/api/cites',
           headers: { 'HTTP_API_KEY' => user.api_key },
           params: {
             title: 'title',
             intro: 'intro',
             fragment_url: 'https://example.com/#:~:text=Example,-Domain',
             link_url: ''
           }

      expect(response).to have_http_status(:created)
      expect(response.parsed_body).to eq(
        'title' => 'title',
        'url' => entity_path(Entity.last)
      )
    end
  end

  describe 'protected endpoint' do
    let(:url) { '/api/entities_mentions/find_by_url_and_entity' }
    let(:http_method) { :get }

    it_behaves_like 'protected endpoint'
  end
end
