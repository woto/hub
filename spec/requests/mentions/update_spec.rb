# frozen_string_literal: true

require 'rails_helper'

describe 'EntitiesController#update', responsible: :admin do
  let(:user) { create(:user) }
  let(:entity) { create(:entity) }
  let(:mention) { create(:mention, user: user) }

  before do
    sign_in(user)
  end

  it 'boosts indexing on update' do
    allow(BoostIndexing).to receive(:call)
    put mention_path(id: mention,
                     mention: {
                       url: 'https://example.com',
                       related_entities: { entity.id => { id: entity.id, is_main: false } }
                     })
    expect(response).to have_http_status(:found)
    expect(BoostIndexing).to have_received(:call).with(url: mention_url(id: mention.reload))
  end
end
