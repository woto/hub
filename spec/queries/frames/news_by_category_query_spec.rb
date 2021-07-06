# frozen_string_literal: true

require 'rails_helper'

describe Frames::NewsByCategoryQuery do
  let(:locale) { :ru }

  context 'when `context.post_category_id` is nil' do
    subject { described_class.call(locale: locale, post_category_id: nil) }

    it 'builds correct query' do
      freeze_time do
        expect(subject.object).to match(
          body: {
            aggregations: {
              group_by_category_id: {
                terms: { field: 'post_category_id_0', size: 100 }
              }
            },
            query: {
              bool: {
                filter: [
                  { term: { "realm_kind.keyword": 'news' } },
                  { term: { "status.keyword": 'accrued_post' } },
                  { term: { "realm_locale.keyword": :ru } },
                  { range: { published_at: { lte: Time.current.utc } } }
                ]
              }
            }
          },
          index: Elastic::IndexName.posts,
          size: 0
        )
      end
    end
  end

  context 'when `context.post_category_id` is present' do
    subject { described_class.call(locale: locale, post_category_id: child_post_category.id) }

    let(:realm) { create(:realm) }
    let(:parent_post_category) { create(:post_category, realm: realm) }
    let(:child_post_category) { create(:post_category, realm: realm, parent: parent_post_category) }

    it 'builds correct query' do
      freeze_time do
        expect(subject.object).to match(
          body: {
            aggregations: {
              group_by_category_id: {
                terms: { field: "post_category_id_#{child_post_category.ancestry_depth + 1}", size: 100 }
              }
            },
            query: {
              bool: {
                filter: contain_exactly(
                  { term: { "realm_kind.keyword": 'news' } },
                  { term: { "status.keyword": 'accrued_post' } },
                  { term: { "realm_locale.keyword": :ru } },
                  { range: { published_at: { lte: Time.current.utc } } },
                  { term: { "post_category_id_#{child_post_category.ancestry_depth}".to_sym => child_post_category.id } }
                )
              }
            }
          },
          index: Elastic::IndexName.posts,
          size: 0
        )
      end
    end
  end
end
