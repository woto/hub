# frozen_string_literal: true

require 'rails_helper'

describe Tables::NewsController, type: :system, responsible: :admin do
  describe 'index' do
    let!(:post) { create(:post, realm_kind: :news, tags: ['', 'tag1'], realm_locale: 'ru', status: :accrued_post) }

    before do
      create(:post, realm_kind: :news, realm_locale: 'ru')
      visit by_tag_news_index_path({ tag: 'tag1', locale: 'ru' })
    end

    it 'lists news with requested tag' do
      expect(page).to have_css('.news-preview', text: post.intro.to_plain_text)
      expect(page).to have_css('.news-preview', count: 1)
    end
  end

  describe 'news-by-month turbo-frame' do
    before do
      visit by_tag_news_index_path({ tag: 'tag1', order: :asc, per: 5, sort: :created_at, locale: 'ru' })
    end

    it 'passes query params to frames' do
      expect(page).to have_css('turbo-frame#news-by-month[src="/ru/frames/news/month?order=asc&per=5&sort=created_at"]')
    end
  end

  describe 'news-by-tag turbo-frame' do
    before do
      visit by_tag_news_index_path({ tag: 'tag1', order: :asc, per: 5, sort: :created_at, locale: 'ru' })
    end

    it 'passes query params to frames' do
      expect(page).to have_css('turbo-frame#news-by-tag[src="/ru/frames/news/tag?order=asc&per=5&sort=created_at&tag=tag1"]')
    end
  end
end
