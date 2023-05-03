# frozen_string_literal: true

require 'rails_helper'

describe Entities::SeekInteractor do
  subject(:interactor) { described_class.call(search_string: 'title', pagination_rule:) }

  let(:pagination_rule) { double }
  let(:lookup) { create(:lookup, title: 'lookup') }
  let(:topic) { create(:topic, title: 'topic') }
  let!(:cite) { create(:cite, entity:, link_url: 'https://cite.ru') }
  let(:entity) { create(:entity, title: 'title', intro: 'intro', lookups: [lookup], topics: [topic]) }

  before do
    allow(pagination_rule).to receive(:page).and_return(1)
    allow(pagination_rule).to receive(:per).and_return(1)
    entity.reload
    entity.__elasticsearch__.index_document
    Entity.__elasticsearch__.refresh_index!
  end

  it 'conforms result format' do
    expect(interactor).to have_attributes(
      object: contain_exactly(
        include(
          entity_id: 1,
          entity_url: '/entities/1',
          title: 'title',
          intro: 'intro',
          entities_mentions_count: 0,
          images: [],
          kinds: [{ id: 1, title: 'topic' }],
          links: ['https://cite.ru'],
          lookups: [{ id: 1, title: 'lookup' }]
        )
      )
    )
  end
end
