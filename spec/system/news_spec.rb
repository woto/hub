# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NewsController, browser: :desktop do
  describe '#show' do
    let!(:news1) { create(:post, published_at: Time.zone.parse('2020-02-03 22:00')) }
    let!(:news2) { create(:post, published_at: Time.zone.parse('2020-04-05 00:00')) }
    let!(:news3) { create(:post, published_at: Time.zone.parse('2020-04-07 02:00'), tags: ['tag']) }
    let!(:news4) { create(:post, published_at: Time.zone.parse('2020-04-07 02:01')) }

    before do
      visit news_path(news3)
    end

    it 'works', :aggregate_failures do
      expect(page).to have_css('h1', text: 'Новости'), 'has correct title'
      expect(page).to have_css('h2', text: news3.title), 'has correct subtitle'
      expect(page).to have_css('.news-content:nth-child(2)', text: news3.body.to_plain_text), 'has correct body'
      expect(page).to have_css('.news-date', text: ApplicationController.helpers.l(news3.published_at.to_date, locale: 'ru')), 'has correct publication date'
    end

    describe 'turbo-frame' do
      it 'has correct src' do
        expect(page).to have_css('turbo-frame#news-by-month[src="/ru/frames/news/month"]')
        expect(page).to have_css('turbo-frame#news-by-tag[src="/ru/frames/news/tag"]')
      end
    end

    describe 'language_component' do
      it_behaves_like 'shared language_component' do
        let(:link) { news_index_path(locale: 'en') }
      end
    end
  end
end
