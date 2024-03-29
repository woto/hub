# frozen_string_literal: true

require 'rails_helper'

describe Import::Offers::FavoriteIdsInteractor do
  subject { described_class.call(offer, advertiser, feed) }

  let(:advertiser) { create(:advertiser) }
  let(:feed) { create(:feed) }

  context 'when feed_category_ids is not empty' do
    let(:offer) { { Import::Offers::CategoryInteractor::CATEGORY_IDS_KEY => category_ids } }
    let(:category_ids) { [Faker::Number.number, Faker::Number.number] }

    it 'fills favorite_ids correctly' do
      subject
      expect(offer).to include(
        Import::Offers::FavoriteIdsInteractor::FAVORITE_IDS_KEY => contain_exactly(
          "advertiser_id:#{advertiser.id}",
          "feed_id:#{feed.id}",
          *category_ids.map { |category_id| "feed_category_id:#{category_id}" }
        )
      )
    end
  end

  context 'when feed_category_ids is empty' do
    let(:offer) { { Import::Offers::CategoryInteractor::CATEGORY_IDS_KEY => [] } }

    it 'does not raise error' do
      subject
    end
  end
end
