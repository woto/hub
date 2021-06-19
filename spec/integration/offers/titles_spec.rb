# frozen_string_literal: true

require 'rails_helper'

describe Tables::OffersController, type: :system do
  before { OfferCreator.call(feed_category: feed_category) }

  let(:feed_category) { create(:feed_category) }
  let(:feed) { feed_category.feed }
  let(:advertiser) { feed.advertiser }

  describe 'GET /offers' do
    specify do
      visit offers_path(locale: :ru)
      expect(page).to have_title 'Все товары'
      expect(page).to have_css('h1', text: 'Все товары')
    end
  end

  describe 'GET /advertisers/:advertiser_id/offers' do
    specify do
      visit advertiser_offers_path(advertiser_id: advertiser.id, locale: :ru)
      expect(page).to have_title("Рекламодатель: #{advertiser.to_label}")
      expect(page).to have_css('h1', text: "Рекламодатель: #{advertiser.to_label}")
    end
  end

  describe 'GET /feeds/:feed_id/offers' do
    specify do
      visit feed_offers_path(feed_id: feed.id, locale: :ru)
      expect(page).to have_title("Прайс лист: #{feed.to_label}")
      expect(page).to have_css('h1', text: "Прайс лист: #{feed.to_label}")
    end
  end

  describe 'GET /feed_categories/:feed_category_id/offers' do
    specify do
      visit feed_category_offers_path(feed_category_id: feed_category.id, locale: :ru)
      expect(page).to have_title("Категория: #{feed_category.to_label}")
      expect(page).to have_css('h1', text: "Категория: #{feed_category.to_label}")
    end
  end

  describe 'GET /offers?favorite_id=:id' do
    specify do
      favorite = create(:favorite, kind: :offers)
      login_as(favorite.user, scope: :user)
      visit offers_path(favorite_id: favorite.id, locale: :ru)
      expect(page).to have_title "Избранное: #{favorite.to_label}"
      expect(page).to have_css('h1', text: "Избранное: #{favorite.to_label}")
    end
  end
end
