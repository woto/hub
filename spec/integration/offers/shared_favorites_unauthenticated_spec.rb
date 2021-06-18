# frozen_string_literal: true

require 'rails_helper'

describe Tables::OffersController, type: :system do
  let!(:offer) { OfferCreator.call(feed_category: feed_category) }

  let(:feed_category) { create(:feed_category) }
  let(:feed) { feed_category.feed }
  let(:advertiser) { feed.advertiser }

  describe 'GET /offers' do
    before do
      visit offers_path(locale: 'ru')
    end

    # advertiser_id
    it_behaves_like 'shared_favorites_unauthenticated' do
      before do
        click_on("favorite-advertiser_id-#{offer['advertiser_id']}")
      end
    end

    # _id
    it_behaves_like 'shared_favorites_unauthenticated' do
      before do
        click_on("favorite-_id-#{offer['_id']}")
      end
    end
  end

  describe 'GET /advertisers/:advertiser_id/offers' do
    before do
      visit advertiser_offers_path(advertiser_id: advertiser.id, locale: 'ru')
    end

    # advertiser_id
    it_behaves_like 'shared_favorites_unauthenticated' do
      before do
        click_on("favorite-advertiser_id-#{offer['advertiser_id']}")
      end
    end

    # feed_id
    it_behaves_like 'shared_favorites_unauthenticated' do
      before do
        click_on("favorite-feed_id-#{offer['feed_id']}")
      end
    end

    # _id
    it_behaves_like 'shared_favorites_unauthenticated' do
      before do
        click_on("favorite-_id-#{offer['_id']}")
      end
    end
  end

  describe 'GET /feeds/:feed_id/offers' do
    before do
      visit feed_offers_path(feed_id: feed.id, locale: 'ru')
    end

    # feed_id
    it_behaves_like 'shared_favorites_unauthenticated' do
      before do
        click_on("favorite-feed_id-#{offer['feed_id']}")
      end
    end

    # feed_category_id
    it_behaves_like 'shared_favorites_unauthenticated' do
      before do
        click_on("favorite-feed_category_id-#{offer['feed_category_id']}")
      end
    end

    # _id
    it_behaves_like 'shared_favorites_unauthenticated' do
      before do
        click_on("favorite-_id-#{offer['_id']}")
      end
    end
  end

  describe 'GET /feed_categories/:feed_category_id/offers' do
    before do
      visit feed_category_offers_path(feed_category_id: feed_category.id, locale: 'ru')
    end

    # feed_category_id
    it_behaves_like 'shared_favorites_unauthenticated' do
      before do
        click_on("favorite-feed_category_id-#{offer['feed_category_id']}")
      end
    end

    # _id
    it_behaves_like 'shared_favorites_unauthenticated' do
      before do
        click_on("favorite-_id-#{offer['_id']}")
      end
    end
  end
end
