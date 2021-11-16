# frozen_string_literal: true

require 'rails_helper'

describe API::Mentions, type: :request, responsible: :admin do
  let!(:user) { create(:user) }

  describe 'GET /api/mentions/entities' do
    context 'with entity which includes only title' do
      let!(:entity) do
        create(:entity, title: 'test another word', aliases: [],
                        picture: Rack::Test::UploadedFile.new(file_fixture('avatar.png')))
      end

      it 'autocompletes entities by title' do
        get '/api/mentions/entities', headers: { 'HTTP_API_KEY' => user.api_key }, params: { q: 'anothe' }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to match([{ 'aliases' => [],
                                                      'id' => entity.id.to_s,
                                                      'picture' => be_a(String),
                                                      'score' => 1.0,
                                                      'title' => 'test another word' }])
      end
    end

    context 'with entity which includes aliases' do
      let!(:entity) do
        create(:entity, title: 'word', aliases: %w[first second],
                        picture: Rack::Test::UploadedFile.new(file_fixture('avatar.png')))
      end

      it 'autocompletes entities by aliases' do
        get '/api/mentions/entities', headers: { 'HTTP_API_KEY' => user.api_key }, params: { q: 'secon' }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to match([{ 'aliases' => %w[first second],
                                                      'id' => entity.id.to_s,
                                                      'picture' => be_a(String),
                                                      'score' => be_a(Numeric),
                                                      'title' => 'word' }])
      end
    end
  end

  describe 'GET /api/mentions/urls' do
    let!(:mention) do
      create(:mention, url: 'https://example.com?foo=bar',
                       screenshot: Rack::Test::UploadedFile.new(file_fixture('avatar.png')))
    end

    it 'autocompletes mentions by url' do
      get '/api/mentions/urls', headers: { 'HTTP_API_KEY' => user.api_key }, params: { q: 'https://example.com' }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to match([{ 'score' => be_a(Numeric),
                                                    'screenshot' => be_a(String),
                                                    'url' => 'https://example.com?foo=bar' }])
    end
  end

  describe 'GET /api/mentions/tags' do
    let!(:mention) do
      create(:mention, tags: %w[first second])
      create(:mention, tags: %w['', third])
    end

    it 'autocompletes mentions by tags' do
      get '/api/mentions/tags', headers: { 'HTTP_API_KEY' => user.api_key }, params: { q: 'secon' }

      expect(response).to have_http_status(:ok)
      # TODO: it should return only 'second' tag
      expect(JSON.parse(response.body)).to match([{ 'title' => 'first' }, { 'title' => 'second' }])
    end
  end
end
