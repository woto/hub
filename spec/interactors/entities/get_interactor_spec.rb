# frozen_string_literal: true

require 'rails_helper'

# NOTE: it is a little bit fragile. improve it later

describe Entities::GetInteractor do
  subject(:interactor) { described_class.call(params) }

  let!(:lookup) { create(:lookup, title: 'lookup') }
  let!(:topic) { create(:topic, title: 'topic') }
  let!(:cite) { create(:cite, entity:, link_url: 'https://cite.ru') }
  let!(:entity) { create(:entity, title: 'title', intro: 'intro', lookups: [lookup], topics: [topic]) }
  let(:params) { { id: entity.id } }
  # before do
  #   puts Entity.count
  # end

  it 'conforms result format' do
    expect(interactor).to have_attributes(
      object: include(
        entity_id: entity.id,
        entity_url: "/entities/#{entity.id}-title",
        title: 'title',
        intro: 'intro',
        entities_mentions_count: entity.entities_mentions_count,
        images: [],
        kinds: [{ id: topic.id, title: 'topic' }],
        links: ['https://cite.ru'],
        lookups: [{ id: lookup.id, title: 'lookup' }]
      )
    )
  end

  context 'when :id is passed' do
    let(:params) { {id: entity2.id} }
    let!(:entity1) { create(:entity) }
    let!(:entity2) { create(:entity) }
    let!(:entity3) { create(:entity) }

    it 'returns entity with that id' do
      expect(interactor).to have_attributes(
        object: include(
          entity_id: entity2.id
        )
      )
    end
  end

  context 'when :id is not passed' do
    let(:params) { {} }
    let!(:entity1) { create(:entity) }
    let!(:entity2) { create(:entity) }
    let!(:entity3) { create(:entity) }

    it 'returns random entity' do
      expect(Entity).to receive(:order).with('RANDOM()').and_return([entity2])

      expect(interactor).to have_attributes(
        object: include(
          entity_id: entity2.id
        )
      )
    end
  end
end
