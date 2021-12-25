# frozen_string_literal: true

require 'rails_helper'

describe 'EntitiesController#update', responsible: :admin do
  let(:user) { create(:user) }
  let(:entity) { create(:entity, user: user) }

  before do
    sign_in(user)
  end

  it 'boosts indexing on update' do
    allow(BoostIndexing).to receive(:call)
    put entity_path(id: entity, entity: { title: 'title' })
    expect(response).to have_http_status(:found)
    expect(BoostIndexing).to have_received(:call).with(url: entity_url(id: entity.reload))
  end
end
