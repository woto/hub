# frozen_string_literal: true

require 'rails_helper'

describe Elastic::FeedOffersCountInteractor do
  subject { described_class.call(feed: feed) }

  let(:feed) { create(:feed) }

  before do
    create(:offer, feed_id: feed.id, refresh: refresh)
  end

  context 'when document not refreshed in index yet' do
    let(:refresh) { false }

    it 'does not count them' do
      expect(subject.object).to eq(0)
    end
  end

  context 'when document refreshed in index already' do
    let(:refresh) { true }

    it 'counts them' do
      expect(subject.object).to eq(1)
    end
  end
end
