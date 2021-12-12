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
      index: Elastic::IndexName.pick('offers').scoped,
      routing: feed.id
    )
  end

  context 'when calls' do
    subject do
      GlobalHelper.elastic_client.count(
        described_class.call(
          feed: feed_category.feed
        ).object
      )
    end

    let(:feed_category) { create(:feed_category) }

    before do
      OfferCreator.call(feed_category: create(:feed_category))
      OfferCreator.call(feed_category: feed_category)
    end

    it 'counts offers correctly' do
      expect(subject).to include('count' => 1)
    end
  end
end
