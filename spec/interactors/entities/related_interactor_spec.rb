# frozen_string_literal: true

require 'rails_helper'

# NOTE: it is a little bit fragile. improve it later

describe Entities::RelatedInteractor do
  subject(:interactor) do
    described_class.call(
      mentions_search_string:,
      entity_ids:,
      entities_search_string:
    )
  end

  let(:entity_ids) { [] }
  let(:mentions_search_string) { '' }
  let(:entities_search_string) { '' }

  context 'with simple entities, mentions data' do
    let(:lookup) { create(:lookup) }
    let(:topic) { create(:topic) }
    let!(:cite) { create(:cite, entity:, link_url: 'https://cite.ru') }
    let!(:entity) { create(:entity, title: 'entity_title_1', intro: 'intro', lookups: [lookup], topics: [topic]) }
    let!(:mention) { create(:mention, title: 'mention_title', entities: [entity]) }
    let(:entity_ids) { [entity.id] }
    let(:mentions_search_string) { mention.title }
    let(:entities_search_string) { 'entity_title_' }

    before do
      entity.reload.__elasticsearch__.index_document
      Entity.__elasticsearch__.refresh_index!
      Mention.__elasticsearch__.refresh_index!
    end

    it 'returns response with correct fields' do
      expect(interactor).to have_attributes(
        object: contain_exactly(
          include(
            entity_id: entity.id,
            entity_url: start_with("/entities/#{entity.id}"),
            title: entity.title,
            intro: entity.intro,
            entities_mentions_count: 1,
            kinds: [{ id: topic.id, title: topic.title }],
            links: ['https://cite.ru'],
            lookups: [{ id: lookup.id, title: lookup.title }]
          )
        )
      )
    end
  end

  context 'with shared entities structure' do
    include_context 'with some entities/mentions structure'

    before do
      Entity.__elasticsearch__.refresh_index!
      Mention.__elasticsearch__.refresh_index!
    end

    context 'when searches :entity02' do
      let(:entity_ids) { [entity02.id] }

      it 'returns entities which occurs in mentions with :entity02' do
        expect(interactor).to have_attributes(
          object: contain_exactly(
            include(entity_id: entity01.id, count: 2),
            include(entity_id: entity02.id, count: 5),
            include(entity_id: entity03.id, count: 2),
            include(entity_id: entity04.id, count: 1),
            include(entity_id: entity20.id, count: 5)
          )
        )
      end
    end

    context 'when searches :entity02 with entities_search_string' do
      let(:entity_ids) { [entity02.id] }
      let(:entities_search_string) { 'Angel' }

      it 'returns entities which occurs in mentions with :entity02 and which titles starts with Angel' do
        expect(interactor).to have_attributes(
          object: contain_exactly(
            include(entity_id: entity03.id, count: 2)
          )
        )
      end
    end

    context 'when searches :entity02 with mentions_search_string' do
      let(:entity_ids) { [entity02.id] }
      let(:mentions_search_string) { 'Mia Khalifa' }

      it 'returns entities that occur in mentions which matched the mentions_search_string' do
        expect(interactor).to have_attributes(
          object: contain_exactly(
            include(entity_id: entity01.id),
            include(entity_id: entity02.id),
            include(entity_id: entity20.id)
          )
        )
      end
    end

    context 'when search :entity02 and :entity04' do
      let(:entity_ids) { [entity02.id, entity04.id] }

      it 'returns entities that occur in the same mention' do
        expect(interactor).to have_attributes(
          object: contain_exactly(
            include(entity_id: entity02.id),
            include(entity_id: entity04.id),
            include(entity_id: entity20.id)
          )
        )
      end
    end
  end
end
