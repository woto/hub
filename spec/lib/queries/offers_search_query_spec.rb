# frozen_string_literal: true

require 'rails_helper'

describe OffersSearchQuery do
  subject { described_class.call(args).object }

  context 'with context.feed_id' do
    context 'when context.feed_id was passed' do
      let(:args) { { feed_id: 'feed_id' } }

      specify do
        expect(subject).to include(index: 'feed_id.test.offers')
      end
    end

    context 'when context.feed_id was not passed' do
      let(:args) { {} }

      specify do
        expect(subject).to include(index: '*.test.offers')
      end

      specify do
        expect(subject).to include(
          body: include(
            aggregations: include(
              feeds: {
                terms: {
                  field: '_index',
                  size: 20
                }
              }
            )
          )
        )
      end
    end
  end

  context 'with context.q' do
    context 'when context.q passed' do
      let(:args) { { q: 'Some text' } }

      specify do
        expect(subject).to include(
          body: include(
            {
              query: {
                bool: {
                  must: [{
                    query_string: { query: 'Some text' }
                  }]
                }
              }
            },
            {
              highlight: {
                fields: { "description.#": {}, "name.#": {} },
                tags_schema: :styled
              }
            }
          )
        )
      end
    end

    context 'when context.q was not passed' do
      let(:args) { {} }

      specify do
        expect(subject).to include(
          body: include(
            query: {
              bool: {
                filter: [{ match_all: {} }]
              }
            }
          )
        )
      end
    end
  end

  context 'when context.profile passed' do
    let(:args) { { profile: '1' } }

    specify do
      expect(subject).to include(body: include(profile: true))
    end
  end

  context 'when context.explain passed' do
    let(:args) { { explain: '1' } }

    specify do
      expect(subject).to include(body: include(explain: true))
    end
  end

  pending 'per'
  pending 'page'
  pending 'size'

  context 'when context.context_id and context.category_id and context.q are blank' do
    let(:args) {}

    specify do
      expect(subject).to include(
        body: include(
          sort: [
            { indexed_at: { order: :desc } }
          ]
        )
      )
    end
  end

  context 'with context.category_id' do
    let(:feed) { create(:feed) }

    context 'when context.category_id was not passed' do
      let(:args) { { feed_id: feed.id } }

      specify do
        expect(subject).to include(
          body: include(
            aggregations: include(
              categories: {
                terms: {
                  field: 'category_level_0',
                  size: 20
                }
              }
            )
          )
        )
      end
    end

    context 'when context.category_id was passed' do
      let(:parent) { create(:feed_category, feed: feed) }
      let(:category) { create(:feed_category, parent: parent, feed: feed) }
      let(:level) { category.ancestry_depth }

      context 'regardless of context.only' do
        let(:args) { { feed_id: feed.id, category_id: category.id } }

        specify do
          expect(subject).to include(
            body: include(
              aggregations: include(
                categories: {
                  terms: {
                    field: "category_level_#{level + 1}",
                    size: 20
                  }
                },
                category: {
                  filter: {
                    term: {
                      feed_category_id: category.id
                    }
                  }
                }
              )
            )
          )
        end
      end

      context 'without context.only' do
        let(:args) { { category_id: category.id } }

        specify do
          expect(subject).to include(
            body: include(
              query: {
                bool: {
                  filter: include(
                    term: { "category_level_#{level}": category.id }
                  )
                }
              }
            )
          )
        end
      end

      context 'with context.only' do
        let(:args) { { category_id: category.id, only: '1' } }

        specify do
          expect(subject).to include(
            body: include(
              query: {
                bool: {
                  filter: include(
                    term: { 'feed_category_id': category.id }
                  )
                }
              }
            )
          )
        end
      end
    end
  end
end
