# frozen_string_literal: true

require 'rails_helper'

# NOTE: it is a little bit fragile. improve it later

describe Entities::RelatedInteractor do
  subject(:interactor) { described_class.call(q: mention.title, entity_id: entity1.id, entity_title: 'entity_title_') }

  let(:lookup) { create(:lookup, title: 'lookup') }
  let(:topic) { create(:topic, title: 'topic') }
  let!(:cite1) { create(:cite, entity: entity1, link_url: 'https://cite.ru') }
  let!(:cite2) { create(:cite, entity: entity2) }
  let(:entity1) { create(:entity, title: 'entity_title_1', intro: 'intro', lookups: [lookup], topics: [topic]) }
  let(:entity2) { create(:entity, title: 'entity_title_2') }
  let(:mention) { create(:mention, title: 'mention_title', entities: [entity1, entity2]) }

  before do
    entity1.reload
    entity2.reload
    entity1.__elasticsearch__.index_document
    entity2.__elasticsearch__.index_document
    mention.__elasticsearch__.index_document
    Entity.__elasticsearch__.refresh_index!
    Mention.__elasticsearch__.refresh_index!
  end

  it 'returns both mentioned entities' do
    expect(interactor).to have_attributes(
      object: contain_exactly(
        include(
          entity_id: entity1.id.to_s,
          entity_url: "https://public.ru/entities/#{entity1.id}",
          title: entity1.title,
          intro: entity1.intro,
          entities_mentions_count: 0,
          images: [],
          kinds: [{ 'id' => 1, 'title' => 'topic' }],
          links: ['https://cite.ru'],
          lookups: [{ 'id' => 1, 'title' => 'lookup' }]
        ),
        include(
          entity_id: entity2.id.to_s,
          title: entity2.title
        )
      )
    )
  end
end
