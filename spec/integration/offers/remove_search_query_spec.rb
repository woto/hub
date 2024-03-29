# frozen_string_literal: true

require 'rails_helper'

xdescribe Tables::OffersController, type: :system do
  let!(:offer) { OfferCreator.call(feed_category: create(:feed_category)) }
  let(:link_text) { 'Отключить поиск по тексту.' }

  context 'when no offers are found' do
    it 'shows remove search query advice' do
      visit offers_path(q: Faker::Alphanumeric.alphanumeric, locale: :ru)
      expect(page).to have_link(link_text, href: '/ru/offers')
    end
  end

  context 'when at least one offer found' do
    it 'shows remove search query advice' do
      visit offers_path(q: offer['name'].first['#'], locale: :ru)
      expect(page).to have_link(link_text, href: '/ru/offers')
    end

  end
end
