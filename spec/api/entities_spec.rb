# frozen_string_literal: true

require 'rails_helper'
require_relative '../support/shrine_image'

describe API::Entities, type: :request, responsible: :admin do
  let!(:user) { create(:user) }

  describe 'GET /api/entities/{id}' do
    let!(:entity) do
      create(:entity, image_data: ShrineImage.image_data, aliases: ['abc'])
    end

    it 'autocompletes entities by title' do
      get "/api/entities/#{entity.id}", headers: { 'HTTP_API_KEY' => user.api_key }, params: { q: 'anothe' }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to include(
        'id' => entity.id,
        'image' => be_a(String),
        'aliases' => entity.aliases,
        'title' => entity.title
      )
    end
  end
end