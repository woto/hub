# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Offers', browser: :desktop do
  context 'with 2 feeds for 1 advertiser' do
    let!(:advertiser) { create(:advertisers_admitad) }
    let!(:feed1) { create(:feed, :with_attempt_uuid, advertiser: advertiser, xml_file_path: file_fixture('feeds/yml-simplified.xml')) }
    let!(:feed2) { create(:feed, :with_attempt_uuid, advertiser: advertiser, xml_file_path: file_fixture('feeds/yml-custom.xml')) }

    before do
      Feeds::Parse.call(feed: feed1)
      Feeds::Parse.call(feed: feed2)
      elastic_client.indices.refresh
    end

    it 'runs big test', :aggregate_failures do
      when_search_in_root
      breadcrumbs_inside_feed_root
      breadcrumbs_inside_category
    end

    def when_search_in_root
      visit offers_path(q: 'Мороженица')
      expect(page).to have_css('.item_offer', count: 2)
    end

    def breadcrumbs_inside_feed_root
      visit feed_offers_path(feed_id: feed1.slug_with_advertiser, q: 'Мороженица')
      expect(page).to have_css('.breadcrumb-item.active', text: "#{advertiser.name} - #{feed1.name}")
    end

    def breadcrumbs_inside_category
      cat = feed1.feed_categories.find_by(ext_id: '10')
      visit feed_offers_path(feed_id: feed1.slug_with_advertiser, q: 'Мороженица', category_id: cat.id, locale: 'ru')

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

  context 'with petshop' do
    let!(:advertiser) { create(:advertisers_admitad) }
    let!(:feed) { create(:feed, :with_attempt_uuid, advertiser: advertiser, xml_file_path: file_fixture('feeds/776-petshop+678-taganrog.xml')) }

    before do
      Feeds::Parse.call(feed: feed)
      elastic_client.indices.refresh
    end

    it 'runs big test', :aggregate_failures do
      when_search_in_root
      when_search_in_feed_root
      when_search_in_category_with_nested_categories_and_products_in_this_one
      when_there_is_more_than_twenty_categories
      left_categories_links_preserves_q
      breadcrumbs_inside_category
    end

    def when_search_in_root
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
      visit feed_offers_path(feed_id: feed.slug_with_advertiser, q: 'для кошек', category_id: cat.id)
      expect(page).to have_css('.left_feed_category', count: 20)
      expect(page).to have_text('SEE ALSO')
      expect(page).to have_text('2 more...')
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
