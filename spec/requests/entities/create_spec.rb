# frozen_string_literal: true

require 'rails_helper'

describe 'EntitiesController#create', responsible: :admin do
  let(:user) { create(:user) }

  before do
    sign_in(user)
  end

  it 'boosts indexing on create' do
    allow(BoostIndexing).to receive(:call)
    post entities_path({ entity: { title: 'title' } })
    expect(response).to have_http_status(:found)
    expect(BoostIndexing).to have_received(:call).with(url: entity_url(id: Entity.last))
  end
end
