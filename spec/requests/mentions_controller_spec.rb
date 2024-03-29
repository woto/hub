# frozen_string_literal: true

require 'rails_helper'

describe MentionsController do
  let!(:entity) { create(:entity) }
  let!(:mention) { create(:mention, entities: [entity], title: 'Mention title') }

  before do
    Mention.__elasticsearch__.refresh_index!
  end

  context 'when requested :show action' do
    xit 'includes static html of mention and entity' do
      get mentions_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(mention_path(mention))
      expect(response.body).to include('Mention title')
      expect(response.body).to include(entity_path(entity))
      expect(response.body).to include(entity.title)
    end
  end

  context 'when requested :index action' do
    xit 'includes static html of mention and entity' do
      get mention_path(mention)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(mention_path(mention))
      expect(response.body).to include('Mention title')
      expect(response.body).to include(entity_path(entity))
      expect(response.body).to include(entity.title)
    end
  end
end
