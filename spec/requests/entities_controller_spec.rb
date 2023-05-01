# frozen_string_literal: true

require 'rails_helper'

describe EntitiesController do
  let!(:entity) { create(:entity) }
  let!(:mention) { create(:mention, entities: [entity], title: 'Mention title') }

  before do
    Mention.__elasticsearch__.refresh_index!
  end

  it 'includes static html of mention and entity' do
    get entity_path(entity)
    expect(response).to have_http_status(:ok)
    expect(response.body).to include(mention_path(mention))
    expect(response.body).to include('Mention title')
    expect(response.body).to include(entity_path(entity))
    expect(response.body).to include(entity.title)
  end
end
