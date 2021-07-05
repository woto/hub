# frozen_string_literal: true

require 'rails_helper'

describe Frames::NewsByTagSearchQuery do
  subject { described_class.call(locale: locale) }

  let(:locale) { :ru }

  it 'builds correct query' do
    freeze_time do
      expect(subject.object).to match(
        {
          body: {
            aggregations: {
              group_by_tag: {
                terms:
                  { field: 'tags.keyword', size: 20 }
              }
            },
            query: {
              bool: {
                filter: contain_exactly(
                  { term: { "realm_kind.keyword": 'news' } },
                  { term: { "status.keyword": 'accrued_post' } },
                  { term: { "realm_locale.keyword": :ru } },
                  { range: { published_at: { lte: Time.current.utc } } }
                )
              }
            }
          },
          index: Elastic::IndexName.posts,
          size: 0
        }
      )
    end
  end
end
