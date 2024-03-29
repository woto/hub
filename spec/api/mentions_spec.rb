# frozen_string_literal: true

require 'rails_helper'
require_relative '../support/shrine_image'

describe API::Mentions, type: :request, responsible: :admin do
  let!(:user) { create(:user) }

  describe 'GET /api/mentions/entities' do
    context 'with entity which includes only title' do
      let!(:entity) do
        create(:entity, title: 'test another word', lookups: [],
                        images: [create(:image)])
      end

      xit 'autocompletes entities by title' do
        get '/api/mentions/entities', headers: { 'HTTP_API_KEY' => user.api_key }, params: { q: 'anothe' }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to match([{ 'lookups' => [],
                                                      'id' => entity.id.to_s,
                                                      'image' => be_a(Hash),
                                                      'score' => be_a(Numeric),
                                                      'title' => 'test another word',
                                                      'topics' => [] }])
      end
    end

    context 'with entity which includes lookups' do
      let!(:entity) do
        create(:entity, title: 'word', lookups: [create(:lookup, title: 'first'), create(:lookup, title: 'second')],
                        images: [create(:image)])
      end

      xit 'autocompletes entities by lookups' do
        get '/api/mentions/entities', headers: { 'HTTP_API_KEY' => user.api_key }, params: { q: 'secon' }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to match([{ 'lookups' => %w[first second],
                                                      'id' => entity.id.to_s,
                                                      'image' => be_a(Hash),
                                                      'score' => be_a(Numeric),
                                                      'title' => 'word',
                                                      'topics' => [] }])
      end
    end
  end

  describe 'GET /api/mentions/urls' do
    let!(:mention) do
      create(:mention, url: 'https://example.com?foo=bar')
    end

    xit 'autocompletes mentions by url' do
      get '/api/mentions/urls', headers: { 'HTTP_API_KEY' => user.api_key }, params: { q: 'https://example.com' }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to match([{ 'score' => be_a(Numeric),
                                                    'image' => include(
                                                      'width',
                                                      'height',
                                                      'original' => be_a(String),
                                                      'thumbnails' => be_a(Hash)
                                                    ),
                                                    'url' => 'https://example.com?foo=bar',
                                                    'title' => mention.title }])
    end
  end
end
