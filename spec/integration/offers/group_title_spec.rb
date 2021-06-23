# frozen_string_literal: true

require 'rails_helper'

describe 'group title', type: :system do
  let(:parent_feed_category) { create(:feed_category, feed: feed) }
  let(:child_feed_category) { create(:feed_category, feed: feed, parent: parent_feed_category) }
  let(:feed) { create(:feed) }
  let(:advertiser) { feed.advertiser }

  before do
    OfferCreator.call(feed_category: child_feed_category)
  end

  describe 'GET /offers' do
    specify do
      visit offers_path(per: 2, locale: :ru)
      expect(page).to have_link("Рекламодатель: #{advertiser.to_label}",
                                href: advertiser_offers_path(advertiser_id: advertiser,
                                                             per: 2,
                                                             locale: :ru))
    end
  end

  describe 'GET /advertisers/:advertiser_id/offers' do
    specify do
      visit advertiser_offers_path(advertiser_id: advertiser, per: 2, locale: :ru)
      expect(page).to have_link("Прайс: #{feed.to_label}",
                                href: feed_offers_path(feed_id: feed,
                                                       per: 2,
                                                       locale: :ru))
    end
  end

  describe 'GET /feeds/:feed_id/offers' do
    specify do
      visit feed_offers_path(feed_id: feed, per: 2, locale: :ru)
      expect(page).to have_link("Категория: #{parent_feed_category.to_label}",
                                href: feed_category_offers_path(feed_category_id: parent_feed_category,
                                                                per: 2,
                                                                locale: :ru))
    end
  end

  describe 'GET /feed_categories/:feed_category_id/offers' do
    specify do
      visit feed_category_offers_path(feed_category_id: parent_feed_category, per: 2, locale: :ru)
      expect(page).to have_link("Категория: #{child_feed_category.to_label}",
                                href: feed_category_offers_path(feed_category_id: child_feed_category,
                                                                per: 2,
                                                                locale: :ru))
    end
  end
end
