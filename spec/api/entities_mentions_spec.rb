# frozen_string_literal: true

require 'rails_helper'

describe API::EntitiesMentions, type: :request do
  let!(:user) { create(:user) }

  context 'when there is no such mention' do
    let(:entities_mention) { create(:entities_mention) }

    it 'returns empty mention_date' do
      get '/api/entities_mentions/find_by_url_and_entity',
          headers: { 'HTTP_API_KEY' => user.api_key },
          params: { entity_id: entities_mention.entity.id, url: 'http://example.com' }

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)).to eq({ 'error' => 'EntitiesMention not found' })
    end
  end

  context 'when there is no such entity' do
    let(:entities_mention) { create(:entities_mention) }

    it 'returns empty mention_date' do
      get '/api/entities_mentions/find_by_url_and_entity',
          headers: { 'HTTP_API_KEY' => user.api_key },
          params: { entity_id: 1, url: entities_mention.mention.url }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq({ 'mention_date' => nil })
    end
  end

  context 'when there is an entities_mention without mention_date' do
    let(:entities_mention) { create(:entities_mention) }

    it 'returns empty mention_date' do
      get '/api/entities_mentions/find_by_url_and_entity',
          headers: { 'HTTP_API_KEY' => user.api_key },
          params: { entity_id: entities_mention.entity.id, url: entities_mention.mention.url }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq({ 'mention_date' => nil })
    end
  end

  context 'when there is an entities_mention with mention_date' do
    let(:entities_mention) { create(:entities_mention, mention_date: Date.new(2001, 2, 3)) }

    it 'returns mention_date' do
      get '/api/entities_mentions/find_by_url_and_entity',
          headers: { 'HTTP_API_KEY' => user.api_key },
          params: { entity_id: entities_mention.entity.id, url: entities_mention.mention.url }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq({ 'mention_date' => '2001-02-03T00:00:00.000Z' })
    end
  end

  describe 'protected endpoint' do
    let(:url) { '/api/entities_mentions/find_by_url_and_entity' }
    let(:http_method) { :get }

    it_behaves_like 'protected endpoint'
  end
end
