# frozen_string_literal: true

require 'rails_helper'

describe Frames::NewsByMonthSearchQuery do
  subject { described_class.call(locale: locale) }

  let(:locale) { :ru }

  it 'builds correct query' do
    freeze_time do
      expect(subject.object).to match(
        body: {
          aggregations: {
            group_by_month: {
              date_histogram: {
                field: 'published_at',
                interval: 'month',
                order: { _key: 'desc' }
              }
            }
          },
          query: {
            bool: {
              filter: match_array([
                                    { term: { "realm_kind.keyword": 'news' } },
                                    { term: { "status.keyword": 'accrued_post' } },
                                    { term: { "realm_locale.keyword": 'ru' } },
                                    { range: { published_at: { lte: Time.current.utc } } }
                                  ])
            }
          }
        },
        index: Elastic::IndexName.posts,
        size: 0
      )
    end
  end
end
