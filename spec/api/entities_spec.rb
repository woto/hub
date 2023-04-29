# frozen_string_literal: true

require 'rails_helper'
require_relative '../support/shrine_image'

describe API::Entities, responsible: :admin, type: :request do
  let!(:user) { create(:user) }

  describe 'GET /api/entities/{id}' do
    let(:mention) { create(:mention) }
    let(:image) { create(:image) }
    let(:lookup) { create(:lookup) }
    let(:entity) do
      create(:entity, title: 'foo', images: [image], lookups: [lookup], topics: [topic])
    end
    let(:topic) { create(:topic) }

    before do
      create(:cite, mention:, entity:, link_url: 'https://example.com')
    end

    it 'autocompletes entities by title' do
      get "/api/entities/#{entity.id}", headers: { 'HTTP_API_KEY' => user.api_key }, params: { q: 'another' }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to match(
        'entity_id' => entity.id,
        'entity_url' => "/entities/#{entity.id}-foo",
        'images' => contain_exactly(include('id' => image.id)),
        'entities_mentions_count' => 0,
        'intro' => entity.intro,
        'kinds' => [match('id' => topic.id, 'title' => topic.title)],
        'links' => ['https://example.com'],
        'lookups' => [match('id' => lookup.id, 'title' => lookup.title)],
        'title' => entity.title
      )
    end
  end

  describe 'POST /api/entities/related' do
    let(:entity1) { create(:entity) }
    let(:entity2) { create(:entity) }

    before do
      create(:mention, entities: [entity1, entity2])

      Entity.__elasticsearch__.refresh_index!
      Mention.__elasticsearch__.refresh_index!
    end

    it 'returns related entities' do
      post '/api/entities/related', params: { entity_ids: [entity1.id] }
      expect(response.parsed_body).to contain_exactly(
        include('entity_id' => entity1.id),
        include('entity_id' => entity2.id)
      )
    end
  end

  describe 'GET /api/entities/list' do
    let(:entity) { create(:entity) }

    it 'returns entities list' do
      post '/api/entities/list', params: { entity_ids: [entity.id] }
      expect(response.parsed_body).to contain_exactly(
        include('entity_id' => entity.id)
      )
    end
  end
end
