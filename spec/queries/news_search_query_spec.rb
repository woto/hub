# frozen_string_literal: true

require 'rails_helper'

describe NewsSearchQuery do
  subject do
    described_class.call(locale: 'ru',
                         tag: 'tag',
                         post_category_id: child_category.id,
                         month: month,
                         q: 'q',
                         sort: 'sort',
                         order: 'order',
                         from: 0,
                         size: 100,
                         _source: ['_source'])
  end

  let(:realm) { create(:realm) }
  let(:parent_category) { create(:post_category, realm: realm) }
  let(:child_category) { create(:post_category, realm: realm) }
  let(:month) { Time.zone.parse('2021-12-01') }

  it 'builds search query' do
    freeze_time do
      expect(subject.object).to match(
        {
          body: {
            query: {
              bool: {
                filter: contain_exactly(
                  { term: { "realm_kind.keyword": 'news' } },
                  { term: { "status.keyword": 'accrued_post' } },
                  { term: { "realm_locale.keyword": 'ru' } },
                  { range: { published_at: { lte: Time.current.utc } } },
                  { term: { "tags.keyword": 'tag' } },
                  { term: { "post_category_id_#{child_category.ancestry_depth}": child_category.id } },
                  { range: {
                    published_at: {
                      gte: month.beginning_of_month.utc,
                      lte: month.end_of_month.utc
                    }
                  } }
                ),
                must: [{ query_string: { query: 'q' } }]
              }
            }, sort: [{ sort: { order: 'order' } }]
          },
          from: 0,
          size: 100,
          index: Elastic::IndexName.posts,
          _source: ['_source']
        }
      )
    end
  end
end
