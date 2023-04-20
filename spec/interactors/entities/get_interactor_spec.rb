# frozen_string_literal: true

require 'rails_helper'

# NOTE: it is a little bit fragile. improve it later

describe Entities::GetInteractor do
  subject(:interactor) { described_class.call(id: entity.id) }

  let!(:lookup) { create(:lookup, title: 'lookup') }
  let!(:topic) { create(:topic, title: 'topic') }
  let!(:cite) { create(:cite, entity:, link_url: 'https://cite.ru') }
  let!(:entity) { create(:entity, title: 'title', intro: 'intro', lookups: [lookup], topics: [topic]) }

  # before do
  #   puts Entity.count
  # end

  it 'conforms result format' do
    expect(interactor).to have_attributes(
      object: include(
        entity_id: entity.id,
        entity_url: "https://public.ru/entities/#{entity.id}-title",
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
end
