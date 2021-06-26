# frozen_string_literal: true

require 'rails_helper'

describe Tables::NewsController, type: :system, responsible: :admin do
  describe 'news-by-tag turbo-frame' do
    before do
      visit news_index_path({ order: :asc, per: 5, sort: :created_at, locale: 'ru' })
    end

    it 'passes query params to frame' do
      expect(page).to have_css('turbo-frame#news-by-tag[src="/ru/frames/news/tag?order=asc&per=5&sort=created_at"]')
    end
  end

  describe 'news-by-month turbo-frame' do
    before do
      visit news_index_path({ order: :asc, per: 5, sort: :created_at, locale: 'ru' })
    end

    it 'passes query params to frame' do
      expect(page).to have_css('turbo-frame#news-by-month[src="/ru/frames/news/month?order=asc&per=5&sort=created_at"]')
    end
  end

  context 'without language locale param' do
    let!(:news) { create(:post, realm_locale: 'en-US', realm_kind: :news, status: :accrued_post) }

    before do
      visit news_index_path
    end

    it 'lists news for browser locale' do
      expect(page).to have_css('h1', text: 'News')
      expect(page).to have_css('h2', text: news.title)
    end
  end

  context 'with russian locale param' do
    let!(:news) do
      create(:post, realm_kind: :news, realm_locale: :ru, published_at: Time.current,
                    status: :accrued_post)
    end

    before do
      visit news_index_path({ locale: 'ru' })
    end

    it 'lists russian news' do
      expect(page).to have_css('h1', text: 'Новости')
      expect(page).to have_css('h2', text: news.title)
    end
  end

  context 'when params partially present in request' do
    before do
      visit news_index_path({ per: 1, locale: 'ru' })
    end

    it 'partially uses params in new location path' do
      expect(page).to have_current_path(news_index_path(order: :desc, per: 1, sort: :published_at, locale: 'ru'))
    end
  end

  context 'when params is empty' do
    before do
      visit news_index_path(locale: 'ru')
    end

    it 'redirects to system workspace' do
      expect(page).to have_current_path(news_index_path(order: :desc, per: 20, sort: :published_at, locale: 'ru'))
    end
  end

  context 'when "per" param is 1 and "page" is 2' do
    before do
      create(:post, realm_kind: :news, realm_locale: :ru, status: :accrued_post)
      create(:post, realm_kind: :news, realm_locale: :ru, status: :accrued_post)
      visit news_index_path({ per: 1, page: 2, locale: 'ru' })
    end

    it 'lists one news of two' do
      expect(page).to have_css('h2', count: 1)
      expect(page).to have_text('Отображение 2 - 2 из 2 всего')
    end
  end

  describe 'pagination' do
    before do
      create(:post, realm_kind: :news, realm_locale: :ru, status: :accrued_post)
      create(:post, realm_kind: :news, realm_locale: :ru, status: :accrued_post)
    end

    it 'displays pagination' do
      visit news_index_path({ per: 1, locale: 'ru' })
      expect(page).to have_css('.pagination')
    end
  end

  describe 'preview selector' do
    let!(:post) { create(:post, realm_kind: :news, realm_locale: :ru, status: :accrued_post) }

    it 'wraps intro in selector' do
      visit news_index_path({ locale: 'ru' })
      expect(page).to have_css('.news-preview', text: post.intro.to_plain_text)
    end
  end
end
