# frozen_string_literal: true

require 'rails_helper'

describe 'MentionsController#create', responsible: :admin do
  let(:entity) { create(:entity) }
  let(:user) { create(:user) }

  before do
    sign_in(user)
  end

  it 'boosts indexing on create' do
    allow(BoostIndexing).to receive(:call)
    post mentions_path(mention: {
                         url: 'https://example.com',
                         related_entities: { entity.id => { id: entity.id, is_main: false } }
                       })
    expect(response).to have_http_status(:found)
    expect(BoostIndexing).to have_received(:call).with(url: mention_url(id: Mention.last))
  end
end
