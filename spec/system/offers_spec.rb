# frozen_string_literal: true

require 'rails_helper'

describe 'Offers page' do
  context 'with many feeds' do
    let!(:advertiser) { create(:advertiser) }
    let!(:feed1) { create(:feed, advertiser: advertiser, xml_file_path: file_fixture('feeds/yml-simplified.xml')) }
    let!(:feed2) { create(:feed, advertiser: advertiser, xml_file_path: file_fixture('feeds/yml-custom.xml')) }
    let(:small_household_appliances) { feed1.feed_categories.find_by(ext_id: '10') }

    before do
      20.times do |i|
        feed = create(:feed, name: "feed #{i}", advertiser: advertiser,
                             xml_file_path: file_fixture('feeds/yml-custom.xml'))
        Feeds::Parse.call(feed: feed)
      end
      Feeds::Parse.call(feed: feed1)
      Feeds::Parse.call(feed: feed2)
      elastic_client.indices.refresh
    end

    it 'works', :aggregate_failures do
      when_search_in_root_1
      breadcrumbs_inside_feed_root
      breadcrumbs_inside_category
      left_feeds_for_more_than_20_feeds
    end

    def when_search_in_root_1
      visit offers_path(q: 'Мороженица', locale: 'ru')
      expect(page).to have_css('.item_offer', count: 12)
    end

    def left_feeds_for_more_than_20_feeds
      visit offers_path(q: 'Мороженица', locale: 'ru')
      expect(page).to have_css('.left_feed', count: 20, text: '1')
      expect(page).to have_text('Прайс листы')
      expect(page).to have_text('СМОТРИТЕ ТАКЖЕ')
      expect(page).to have_link('Не отображается: 2 шт.', href: '/404')

      find('.left_feed', match: :first).click
      expect(page).to have_css('.item_offer', count: 1)
    end

    def breadcrumbs_inside_feed_root
      visit feed_offers_path(feed_id: feed1.slug_with_advertiser, q: 'Мороженица')
      expect(page).to have_css('.breadcrumb-item.active', text: "#{advertiser.name} - #{feed1.name}")
    end

    def breadcrumbs_inside_category
      visit feed_offers_path(feed_id: feed1.slug_with_advertiser, q: 'Мороженица',
                             category_id: small_household_appliances.id, locale: 'ru')

      within('.breadcrumb') do
        br = page.find('.breadcrumb-item', text: 'Главная')
        expect(br[:class]).not_to include('active')

        br = page.find('.breadcrumb-item', text: 'Личн. кабинет')
        expect(br[:class]).not_to include('active')

        br = page.find('.breadcrumb-item', text: "#{advertiser.name} - #{feed1.name}")
        expect(br[:class]).not_to include('active')
        br.find('.dropdown-multiple-feeds').click
        within(br) do
          expect(page).to have_text(feed1.name)
          expect(page).to have_text(feed2.name)
        end

        br = page.find('.breadcrumb-item', text: 'Все товары')
        expect(br[:class]).not_to include('active')

        br = page.find('.breadcrumb-item', text: 'Бытовая техника')
        expect(br[:class]).not_to include('active')

        expect(page).to have_css('.breadcrumb-item.active', text: 'Мелкая техника для кухни')
      end
    end
  end

  context 'with many offers' do
    let!(:advertiser) { create(:advertiser) }
    let!(:feed) do
      create(:feed, advertiser: advertiser, xml_file_path: file_fixture('feeds/776-petshop+678-taganrog.xml'))
    end

    before do
      Feeds::Parse.call(feed: feed)
      elastic_client.indices.refresh
    end

    it 'works', :aggregate_failures do
      when_search_in_root_2
      when_search_in_feed_root
      when_search_in_category_with_nested_categories_and_products_in_this_one
      when_there_is_more_than_twenty_categories
      left_categories_links_preserves_q
      breadcrumbs_inside_category
    end

    def when_search_in_root_2
      visit offers_path(q: 'корм для хомяков')
      # TODO
    end

    def when_search_in_feed_root
      cat = feed.feed_categories.find_by(ext_id: '186')
      visit feed_offers_path(feed_id: feed.slug_with_advertiser, q: 'для кошек')
      expect(page).to have_css("#left_feed_category_#{cat.id}.left_feed_category", text: "Товары для кошек\n370")
    end

    def when_search_in_category_with_nested_categories_and_products_in_this_one
      cat = feed.feed_categories.find_by(ext_id: '189')
      visit feed_offers_path(feed_id: feed.slug_with_advertiser, q: 'для кошек', category_id: cat.id)
      expect(page).to have_css('#left_feed_category.left_feed_category', text: "Только эта категория\n3")

      click_link 'Только эта категория'
      expect(page).to have_css('.item_offer', count: 3)
    end

    def when_there_is_more_than_twenty_categories
      cat = feed.feed_categories.find_by(ext_id: '248298374')
      visit feed_offers_path(feed_id: feed.slug_with_advertiser, q: 'для кошек', category_id: cat.id, locale: 'ru')
      expect(page).to have_css('.left_feed_category', count: 20)
      expect(page).to have_text('СМОТРИТЕ ТАКЖЕ')
      expect(page).to have_link('Не отображается: 2 шт.', href: '/404')
    end

    def left_categories_links_preserves_q
      cat = feed.feed_categories.find_by(ext_id: '166')
      visit feed_offers_path(feed_id: feed.slug_with_advertiser, q: 'ягненком', category_id: cat.id)
      click_link 'Паучи', class: 'left_feed_category'
      expect(page).to have_css('.item_offer', count: 3)
    end

    def breadcrumbs_inside_category
      cat = feed.feed_categories.find_by(ext_id: '859')
      visit feed_offers_path(feed_id: feed.slug_with_advertiser, category_id: cat.id, locale: 'ru')

      within('.breadcrumb') do
        br = page.find('.breadcrumb-item', text: 'Главная')
        expect(br[:class]).not_to include('active')

        br = page.find('.breadcrumb-item', text: 'Личн. кабинет')
        expect(br[:class]).not_to include('active')

        br = page.find('.breadcrumb-item', text: feed.name)
        expect(br[:class]).not_to include('active')

        br = page.find('.breadcrumb-item', text: 'Все товары')
        expect(br[:class]).not_to include('active')

        br = page.find('.breadcrumb-item', text: 'Товары для собак')
        expect(br[:class]).not_to include('active')

        br = page.find('.breadcrumb-item', text: 'Сухие корма')
        expect(br[:class]).not_to include('active')

        expect(page).to have_css('.breadcrumb-item.active', text: 'Щенки')
      end
    end
  end
end
