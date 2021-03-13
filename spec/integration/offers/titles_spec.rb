# frozen_string_literal: true

require 'rails_helper'

describe Tables::OffersController, type: :system do
  context 'when visits all offers' do
    it 'shows title with "Все товары"' do
      visit offers_path(locale: :ru)
      expect(page).to have_css('h1', text: 'Все товары')
    end
  end

  context "when visits advertiser's offers" do
    it 'shows correct title' do
      advertiser = create(:advertiser)
      visit advertiser_offers_path(advertiser_id: advertiser.id, locale: :ru)
      expect(page).to have_css('h1', text: "Рекламодатель: #{advertiser.to_label}")
    end
  end

  context "when visits feed's offers" do
    it 'shows correct title' do
      feed = create(:feed)
      visit feed_offers_path(feed_id: feed.id, locale: :ru)
      expect(page).to have_css('h1', text: "Прайс лист: #{feed.to_label}")
    end
  end

  context "when visits feed_category's offers" do
    it 'shows correct title' do
      feed_category = create(:feed_category)
      visit feed_category_offers_path(feed_category_id: feed_category.id, locale: :ru)
      expect(page).to have_css('h1', text: "Категория: #{feed_category.to_label}")
    end
  end

  context "when visits favorite's offers" do
    it 'shows correct title' do
      favorite = create(:favorite, kind: :offers)
      login_as(favorite.user, scope: :user)
      visit offers_path(favorite_id: favorite.id, locale: :ru)
      expect(page).to have_css('h1', text: "Избранное: #{favorite.to_label}")
    end
  end
end
