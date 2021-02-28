# frozen_string_literal: true

require 'rails_helper'

describe FeedOffersCountQuery do
  subject { described_class.call(feed: feed) }

  let(:feed) { create(:feed) }

  it 'builds correct query' do
    expect(subject.object).to eq(
      body: {
        query: {
          term: { feed_id: feed.id }
        }
      },
      index: Elastic::IndexName.offers,
      routing: feed.id
    )
  end
end
