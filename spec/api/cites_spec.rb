# frozen_string_literal: true

require 'rails_helper'

describe API::Cites, type: :request do
  let!(:user) { create(:user) }

  context 'minimal parameters test' do
    it 'creates cite' do
      post '/api/cites',
           headers: { 'HTTP_API_KEY' => user.api_key },
           params: {
             title: 'entity title',
             intro: 'intro',
             fragment_url: 'https://example.com/#:~:text=Example,-Domain',
             link_url: ''
           }

      expect(response).to have_http_status(:created)
      expect(response.parsed_body).to eq(
        'title' => 'entity title',
        'url' => entity_path(Entity.last),
        'entity_title' => 'entity title',
        'entity_url' => entity_path(Entity.last),
        'mention_title' => nil,
        'mention_url' => mention_path(Mention.last)
      )
    end
  end

  describe 'protected endpoint' do
    let(:url) { '/api/entities_mentions/find_by_url_and_entity' }
    let(:http_method) { :get }

    it_behaves_like 'protected endpoint'
  end

  describe 'crawlers' do
    it 'pings crawlers with correct data' do
      allow(BoostIndexingInteractor).to receive(:call)

      post '/api/cites',
           headers: { 'HTTP_API_KEY' => user.api_key },
           params: {
             title: 'title',
             intro: 'intro',
             fragment_url: 'https://example.com/#:~:text=Example,-Domain',
             link_url: ''
           }

      expect(BoostIndexingInteractor).to have_received(:call).with(
        url: entity_url(id: Entity.last, host: GlobalHelper.host, protocol: 'https')
      )
    end
  end
end
