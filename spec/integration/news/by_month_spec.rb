# frozen_string_literal: true

require 'rails_helper'

describe Tables::NewsController, type: :system, responsible: :admin do
  describe 'index' do
    let!(:post) do
      create(:post, realm_kind: :news, realm_locale: :ru, published_at: Time.zone.parse('2020-01-01'),
                    status: :accrued_post)
    end

    before do
      create(:post, realm_kind: :news, status: :accrued_post)
      visit by_month_news_index_path({ month: '2020-01', locale: 'ru' })
    end

    it 'lists news in requested month' do
      expect(page).to have_css('.news-preview', text: post.intro.to_plain_text)
      expect(page).to have_css('.news-preview', count: 1)
    end
  end

  context 'when publication time has not yet come' do
    let(:published_at) { 1.hour.after }

    before do
      create(:post, realm_kind: :news, published_at: published_at)
      visit by_month_news_index_path(
        month: ApplicationController.helpers.l(published_at, format: '%Y-%m'), locale: 'ru'
      )
    end

    it 'does not show news from future (published_at more than now)' do
      expect(page).to have_css('.news-preview', count: 0)
    end
  end

  describe 'news-by-month turbo-frame' do
    before do
      visit by_month_news_index_path({ month: '2020-04', order: :asc, per: 5, sort: :created_at, locale: 'ru' })
    end

    it 'passes query params to frame' do
      expect(page).to have_css('turbo-frame#news-by-month[src="/ru/frames/news/month?month=2020-04&order=asc&per=5&sort=created_at"]')
    end
  end

  describe 'news-by-tag turbo-frame' do
    before do
      visit by_month_news_index_path({ month: '2020-04', order: :asc, per: 5, sort: :created_at, locale: 'ru' })
    end

    it 'passes query params to frame' do
      expect(page).to have_css('turbo-frame#news-by-tag[src="/ru/frames/news/tag?order=asc&per=5&sort=created_at"]')
    end
  end
end
