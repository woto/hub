# frozen_string_literal: true

require 'rails_helper'

describe DeleteOldOffersQuery do
  subject { described_class.call(feed: feed) }

  let(:feed) { create(:feed, :with_attempt_uuid) }

  it 'builds correct query' do
    expect(subject.object).to eq(
      index: Elastic::IndexName.offers,
      routing: feed.id,
      body: {
        query: {
          bool: {
            must_not: {
              term: {
                'attempt_uuid.keyword': feed.attempt_uuid
              }
            },
            filter: {
              term: {
                feed_id: feed.id
              }
            }
          }
        }
      }
    )
  end
end
