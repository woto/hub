# frozen_string_literal: true

require 'rails_helper'
require_relative '../support/shrine_image'

describe API::Mentions, type: :request, responsible: :admin do
  let!(:user) { create(:user) }

  describe 'GET /api/mentions/entities' do
    context 'with entity which includes only title' do
      let!(:entity) do
        create(:entity, title: 'test another word', lookups: [],
                        image_data: ShrineImage.image_data)
      end

      it 'autocompletes entities by title' do
        get '/api/mentions/entities', headers: { 'HTTP_API_KEY' => user.api_key }, params: { q: 'anothe' }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to match([{ 'lookups' => [],
                                                      'id' => entity.id.to_s,
                                                      'image' => be_a(String),
                                                      'score' => 2.0,
                                                      'title' => 'test another word' }])
      end
    end

    context 'with entity which includes lookups' do
      let!(:entity) do
        create(:entity, title: 'word', lookups: [create(:lookup, title: 'first'), create(:lookup, title: 'second')],
                        image_data: ShrineImage.image_data)
      end

      it 'autocompletes entities by lookups' do
        get '/api/mentions/entities', headers: { 'HTTP_API_KEY' => user.api_key }, params: { q: 'secon' }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to match([{ 'lookups' => %w[first second],
                                                      'id' => entity.id.to_s,
                                                      'image' => be_a(String),
                                                      'score' => be_a(Numeric),
                                                      'title' => 'word' }])
      end
    end
  end

  describe 'GET /api/mentions/urls' do
    let!(:mention) do
      create(:mention, url: 'https://example.com?foo=bar')
    end

    it 'autocompletes mentions by url' do
      get '/api/mentions/urls', headers: { 'HTTP_API_KEY' => user.api_key }, params: { q: 'https://example.com' }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to match([{ 'score' => be_a(Numeric),
                                                    'image' => include(
                                                      'width',
                                                      'height',
                                                      'image_original' => be_a(String),
                                                      'image_thumbnail' => be_a(String)
                                                    ),
                                                    'url' => 'https://example.com?foo=bar',
                                                    'title' => mention.title }])
    end
  end

  describe 'GET /api/mentions/topics' do
    let!(:mention) do
      create(:mention, topics: [create(:topic, title: 'first'), create(:topic, title: 'second')])
      create(:mention, topics: [create(:topic, title: 'third')])
    end

    it 'autocompletes mentions by topics' do
      get '/api/mentions/topics', headers: { 'HTTP_API_KEY' => user.api_key }, params: { q: 'secon' }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to match([{ 'title' => 'second' }])
    end
  end
end
