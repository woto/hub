# frozen_string_literal: true

require 'rails_helper'

describe PostCategoriesSearchQuery do
  subject { described_class.call(params) }

  let(:column) { Faker::Alphanumeric.alpha }
  let(:q) { Faker::Alphanumeric.alpha }

  let(:params) do
    {
      q: q, locale: :ru, sort: 'sort', order: 'order',
      from: 0, size: 10, filters: {}, model: 'account',
      _source: [column]
    }
  end

  context 'when `q` is present' do
    it 'includes `q` filter' do
      expect(subject.object).to include(
        from: 0,
        size: 10,
        index: Elastic::IndexName.post_categories,
        _source: [column],
        body: include(
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
      expect(subject.object).to include(
        from: 0,
        size: 10,
        index: Elastic::IndexName.post_categories,
        _source: [column],
        body: include(
          query: {
            bool: {
              filter: [
                { match_all: {} }
              ]
            }
          },
          sort: [sort: { order: 'order' }]
        )
      )
    end
  end
end
