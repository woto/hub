require 'rails_helper'

describe Entities::IndexInteractor do
  before do
    # NOTE: Other entities, listings, mentions
    # which should not appear in results
    entity = create(:entity)
    create(:favorites_item, ext_id: entity.id, kind: 'entities')
    create(:mention, entities: [entity])
  end

  context 'when :entity_ids passed' do
    subject(:interactor) { described_class.call(entity_ids: [entity.id]) }

    let!(:entity) { create(:entity) }

    it 'returns list of entities' do
      expect(interactor).to have_attributes(
        object: contain_exactly(
          include(entity_id: entity.id)
        )
      )
    end
  end

  context 'when :listing_id passed' do
    subject(:interactor) { described_class.call(listing_id: favorites_item.favorite.id) }

    let!(:favorites_item) { create(:favorites_item, ext_id: entity.id, kind: 'entities') }
    let!(:entity) { create(:entity) }

    it 'returns listing entities' do
      expect(interactor).to have_attributes(
        object: contain_exactly(
          include(entity_id: entity.id)
        )
      )
    end
  end

  context 'when :mention_id passed' do
    subject(:interactor) { described_class.call(mention_id: mention.id) }

    let!(:mention) { create(:mention, entities: [entity]) }
    let!(:entity) { create(:entity) }

    it 'returns mention entities' do
      expect(interactor).to have_attributes(
        object: contain_exactly(
          include(entity_id: entity.id)
        )
      )
    end
  end
end
