# frozen_string_literal: true

require 'rails_helper'

describe DeleteOldOffersQuery do
  subject { described_class.call(feed: feed) }

  let(:feed) { create(:feed) }

  it 'builds correct query' do
    expect(subject.object).to eq(
      index: Elastic::IndexName.pick('offers').scoped,
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
