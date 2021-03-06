# frozen_string_literal: true

require 'rails_helper'

describe Elastic::RefreshOffersIndex do
  subject { described_class.call }

  let(:feed) { create(:feed) }
  let(:offer) { create(:offer, feed_id: feed.id, refresh: false) }

  context 'without Elastic::RefreshOffersIndex.call' do
    # does not change because index offers refresh_interval setting is -1
    # and because factory creates without force_refresh
    it 'does not change offers count' do
      expect do
        offer
      end.not_to change { count }
    end
  end

  context 'with Elastic::RefreshOffersIndex.call' do
    it 'changes offers count' do
      expect do
        offer
        subject
      end.to change { count }
    end
  end

  def count
    Elastic::FeedOffersCount.call(feed: feed).object
  end
end