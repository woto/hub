# frozen_string_literal: true

require 'rails_helper'

describe 'group link card', type: :system do
  let(:n) { rand(1..3) }
  let(:parent_feed_category) { create(:feed_category, feed: feed) }
  let(:child_feed_category) { create(:feed_category, feed: feed, parent: parent_feed_category) }
  let(:feed) { create(:feed) }
  let(:advertiser) { feed.advertiser }

  before do
    n.times { OfferCreator.call(feed_category: child_feed_category) }
  end

  describe 'GET /offers' do
    specify do
      visit offers_path(locale: :ru)
      within "#offers-group-more-advertiser_id-#{advertiser.id}" do
        expect(page).to have_text("Товаров в категории:\n#{n}")
        expect(page).to have_link('Перейти', href: advertiser_offers_path(advertiser_id: advertiser, locale: :ru))
      end
    end
  end

  describe 'GET /advertisers/:advertiser_id/offers' do
    specify do
      visit advertiser_offers_path(advertiser_id: advertiser, locale: :ru)
      within "#offers-group-more-feed_id-#{feed.id}" do
        expect(page).to have_text("Товаров в категории:\n#{n}")
        expect(page).to have_link('Перейти', href: feed_offers_path(feed_id: feed, locale: :ru))
      end
    end
  end

  describe 'GET /feeds/:feed_id/offers' do
    specify do
      visit feed_offers_path(feed_id: feed, locale: :ru)
      within "#offers-group-more-feed_category_id-#{parent_feed_category.id}" do
        expect(page).to have_text("Товаров в категории:\n#{n}")
        expect(page).to have_link('Перейти', href: feed_category_offers_path(feed_category_id: parent_feed_category, locale: :ru))
      end
    end
  end

  describe 'GET /feed_categories/:feed_category_id/offers' do
    specify do
      visit feed_category_offers_path(feed_category_id: parent_feed_category, locale: :ru)
      within "#offers-group-more-feed_category_id-#{child_feed_category.id}" do
        expect(page).to have_text("Товаров в категории:\n#{n}")
        expect(page).to have_link('Перейти', href: feed_category_offers_path(feed_category_id: child_feed_category, locale: :ru))
      end
    end
  end
end
