# frozen_string_literal: true

require 'rails_helper'

describe NewsController, type: :system do
  describe 'shared_language_component' do
    it_behaves_like 'shared_language_component' do
      before do
        visit news_index_path
      end

      let(:link) { news_index_path(locale: 'en') }
    end
  end

  describe 'shared_search_everywhere' do
    it_behaves_like 'shared_search_everywhere' do
      let(:news) { create(:post, realm_kind: :news) }

      before do
        visit "/ru/news/#{news.id}"
      end

      let(:params) do
        { controller: 'tables/news', q: q, locale: 'ru', per: 20, sort: :published_at, order: :desc,
          only_path: true }
      end
    end
  end

  describe '#show' do
    let!(:news) do
      create(:post, realm_kind: :news, published_at: Time.zone.parse('2020-04-07 02:00'), tags: %w[tag1 tag2])
    end

    before do
      visit news_path(id: news, per: 1, page: 1, sort: :created_at, order: :asc, locale: 'ru')
    end

    describe 'TODO' do
      it 'has correct title' do
        expect(page).to have_css('h1', text: 'Новости')
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
            tag: news.tags.first, per: 1, sort: :created_at, order: :asc, locale: :ru
          ))
        end
      end

      it 'shows "Back to news" link with correct href' do
        within("[data-test-id='news-card-#{news.id}']") do
          expect(page).to have_link('Назад к новостям', href: news_index_path(
            per: 1, page: 1, sort: :created_at, order: :asc, locale: :ru
          ))
        end
      end

      it 'has correct news-by-month turbo-frame' do
        src = frames_news_month_path(per: 1, sort: :created_at, order: :asc, locale: :ru)
        expect(page).to have_css("turbo-frame#news-by-month[src='#{src}']")
      end

      it 'has correct news-by-tag turbo-frame' do
        src = frames_news_tag_path(per: 1, sort: :created_at, order: :asc, locale: :ru)
        expect(page).to have_css("turbo-frame#news-by-tag[src='#{src}']")
      end
    end
  end
end
