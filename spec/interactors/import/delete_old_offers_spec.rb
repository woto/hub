# frozen_string_literal: true

require 'rails_helper'

describe Import::DeleteOldOffersInteractor do
  subject { described_class.call(feed: feed) }

  let(:feed) { create(:feed) }

  shared_examples 'offers count becomes' do |num|
    before do
      create(:offer, feed_id: feed.id, attempt_uuid: attempt_uuid)
    end

    it 'equals num after executing interactor' do
      # one offer in index initially always
      expect(Elastic::FeedOffersCountInteractor.call(feed: feed).object).to eq(1)
      subject
      # one offer after deleting (without index refreshing)
      expect(Elastic::FeedOffersCountInteractor.call(feed: feed).object).to eq(1)
      Elastic::RefreshOffersIndexInteractor.call(feed: feed)
      # should be equal actual offers amount
      expect(Elastic::FeedOffersCountInteractor.call(feed: feed).object).to eq(num)
    end
  end

  context 'when feed.attempt_uuid does not equal offer attempt_uuid' do
    let(:attempt_uuid) { SecureRandom.uuid }

    it_behaves_like 'offers count becomes', 0
  end

  context 'when feed.attempt_uuid does equal offer attempt_uuid' do
    let(:attempt_uuid) { feed.attempt_uuid }

    it_behaves_like 'offers count becomes', 1
  end
end
