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
    subject(:interactor) { described_class.call(params: { entity_ids: [entity.id] }, current_user: create(:user) ) }

    let!(:entity) { create(:entity) }

    it 'returns entities' do
      expect(interactor).to have_attributes(
        object: contain_exactly(
          include(entity_id: entity.id)
        )
      )
    end
  end

  context 'when :listing_id passed' do
    subject(:interactor) { described_class.call(params: { listing_id: favorites_item.favorite.id }, current_user: create(:user)) }

    let!(:favorites_item) { create(:favorites_item, ext_id: entity.id, kind: 'entities') }
    let!(:entity) { create(:entity) }

    it "returns listing's entities" do
      expect(interactor).to have_attributes(
        object: contain_exactly(
          include(entity_id: entity.id)
        )
      )
    end
  end

  context 'when :mention_id passed' do
    subject(:interactor) { described_class.call(params: { mention_id: mention.id }, current_user: create(:user)) }

    let!(:mention) { create(:mention, entities: [entity]) }
    let!(:entity) { create(:entity) }

    it "returns mention's entities" do
      expect(interactor).to have_attributes(
        object: contain_exactly(
          include(entity_id: entity.id)
        )
      )
    end
  end
end
