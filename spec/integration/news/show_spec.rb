# frozen_string_literal: true

require 'rails_helper'

describe NewsController, type: :system, responsible: :admin do
  describe '#show' do
    let!(:news) do
      create(:post,
             post_category: child_post_category,
             published_at: Time.zone.parse('2020-04-07 02:00'), tags: %w[tag1 tag2])
    end
    let(:realm) { Realm.pick(kind: :news, locale: :ru, domain: 'realm-ru.lvh.me') }
    let(:parent_post_category) { create(:post_category, realm: realm) }
    let(:child_post_category) { create(:post_category, realm: realm, parent: parent_post_category) }

    before do
      switch_realm(news.realm) do
        visit news_path(id: news, per: 1, page: 1, sort: :created_at, order: :asc)
      end
    end

    it 'has correct title' do
      expect(page).to have_css('h1', text: news.title)
    end

    it 'has correct breadcrumbs' do
      expect(page).to have_link(parent_post_category.to_label,
                                href: by_category_news_index_path(
                                  category_id: parent_post_category.id, per: 1, sort: :created_at, order: :asc
                                ))

      expect(page).to have_link(child_post_category.to_label,
                                href: by_category_news_index_path(
                                  category_id: child_post_category.id, per: 1, sort: :created_at, order: :asc
                                ))
    end

    it 'has correct subtitle' do
      expect(page).to have_css('h2', text: news.title)
    end

    it 'has correct body' do
      expect(page).to have_css('.news-content', text: news.body.to_plain_text)
    end

    it 'has correct publication date' do
      expect(page).to have_css('.news-date', text: ApplicationController.helpers.l(
        news.published_at.to_date, locale: 'ru'
      ))
    end

    it 'shows article tag links with correct href' do
      within("[data-test-id='news-card-#{news.id}']") do
        expect(page).to have_link(news.tags.first, href: by_tag_news_index_path(
          tag: news.tags.first, per: 1, sort: :created_at, order: :asc
        ))
      end
    end

    it 'shows "Back to news" link with correct href' do
      within("[data-test-id='news-card-#{news.id}']") do
        expect(page).to have_link('Назад к новостям', href: news_index_path(
          per: 1, page: 1, sort: :created_at, order: :asc
        ))
      end
    end

    it 'has correct news-by-month turbo-frame' do
      src = frames_news_month_path(per: 1, sort: :created_at, order: :asc)
      expect(page).to have_css("turbo-frame#news-by-month[src='#{src}']", visible: :all)
    end

    it 'has correct news-by-tag turbo-frame' do
      src = frames_news_tag_path(per: 1, sort: :created_at, order: :asc)
      expect(page).to have_css("turbo-frame#news-by-tag[src='#{src}']", visible: :all)
    end

    it 'has correct news-by-category turbo-frame' do
      src = frames_news_category_path(per: 1, sort: :created_at, order: :asc)
      expect(page).to have_css("turbo-frame#news-by-category[src='#{src}']", visible: :all)
    end
  end
end
