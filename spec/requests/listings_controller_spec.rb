# frozen_string_literal: true

require 'rails_helper'

describe ListingsController do
  let!(:entity) { create(:entity) }
  let!(:mention) { create(:mention, entities: [entity], title: 'Mention title') }
  let!(:listing_item) { create(:favorites_item, ext_id: entity.id, kind: 'entities') }

  before do
    Mention.__elasticsearch__.refresh_index!
  end

  xit 'includes static html of mention and entity' do
    get listing_path(listing_item.favorite)
    expect(response).to have_http_status(:ok)
    expect(response.body).to include(mention_path(mention))
    expect(response.body).to include('Mention title')
    expect(response.body).to include(entity_path(entity))
    expect(response.body).to include(entity.title)
  end
end
