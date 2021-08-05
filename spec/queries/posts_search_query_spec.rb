# frozen_string_literal: true

require 'rails_helper'

describe PostsSearchQuery do
  subject { described_class.call(params) }

  let(:filter_ids) { [Faker::Number.number] }
  let(:column) { Faker::Alphanumeric.alpha }
  let(:q) { Faker::Alphanumeric.alpha }

  let(:params) do
    {
      q: q, locale: :ru, sort: 'sort', order: 'order',
      from: 0, size: 10, filters: {}, model: 'account',
      filter_ids: filter_ids, _source: [column]
    }
  end

  context 'when `filter_ids` is present' do
    it 'builds correct query' do
      expect(subject.object).to match(
        from: 0,
        size: 10,
        index: Elastic::IndexName.posts,
        _source: [column],
        body: match(
          query: {
            bool: {
              filter: contain_exactly(
                { terms: { user_id: filter_ids } },
              ),
              must: [{ query_string: { query: q } }]
            }
          },
          sort: [sort: { order: 'order' }]
        )
      )
    end
  end

  context 'when `filter_ids` is empty' do
    let(:filter_ids) { nil }

    it 'does not include filter_ids scope' do
      expect(subject.object).to match(
        from: 0,
        size: 10,
        index: Elastic::IndexName.posts,
        _source: [column],
        body: match(
          query: {
            bool: {
              must: [{ query_string: { query: q } }]
            }
          },
          sort: [sort: { order: 'order' }]
        )
      )
    end
  end

  context 'when `q` is empty' do
    let(:q) { nil }

    it 'builds correct query' do
      expect(subject.object).to match(
        from: 0,
        size: 10,
        index: Elastic::IndexName.posts,
        _source: [column],
        body: match(
          query: {
            bool: {
              filter: contain_exactly(
                { terms: { user_id: filter_ids } },
              )
            }
          },
          sort: [sort: { order: 'order' }]
        )
      )
    end
  end
end
