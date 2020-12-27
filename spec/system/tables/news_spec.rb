# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tables::NewsController, browser: :desktop do
  let!(:news1) { create(:post, published_at: Time.zone.parse('2020-02-03 22:00')) }
  let!(:news2) { create(:post, published_at: Time.zone.parse('2020-04-05 00:00')) }
  let!(:news3) { create(:post, published_at: Time.zone.parse('2020-04-07 02:00'), tags: ['tag']) }
  let!(:news4) { create(:post, published_at: Time.zone.parse('2020-04-07 02:01')) }

  let(:params) { {} }

  describe '#index' do
    before do
      visit news_index_path(params)
    end

    it 'has correct titles', :aggregate_failures do
      expect(page).to have_css('h1', text: 'Новости')
      expect(page).to have_css('h2', count: 4), 'has correct subtitle'
    end

    context 'when params is empty' do
      it 'redirects to system workspace' do
        expect(page).to have_current_path(news_index_path(order: :desc, per: 20, sort: :published_at, locale: 'ru'))
      end
    end

    context 'when params partially present in request' do
      let(:params) { { per: 1 } }

      it 'partially uses params in new location path' do
        expect(page).to have_current_path(news_index_path(order: :desc, per: 1, sort: :published_at, locale: 'ru'))
      end
    end

    # login_as(user, scope: :user)

    # context 'when user does not have any workspace' do

    # TODO: Move out. It is not applicable for this controller
    #
    # context 'when user has default workspace' do
    #   before do
    #     user = FactoryBot.create(:user)
    #
    #     sign_in user
    #   end
    #   it 'redirects to user default workspace' do
    #     f
    #   end
    # end

    context 'when "per" param equals 1' do
      let(:params) { { per: 1 } }

      it 'lists exactly the amount of news as "per" parameter' do
        expect(page).to have_css('h2', count: 1)
      end
    end

    context 'when both "page" and "per" equals to 1' do
      let(:params) { { page: 1, per: 1 } }

      it 'works', :aggregate_failures do
        expect(page).to have_css('h2', count: 1), 'lists exactly the amount of articles as "per" parameter'
        expect(page).to have_css('h2', text: news4.title), 'lists correct news item'
        expect(page).to have_css('.pagination'), 'displays pagination'
        expect(page).to have_css('.news-preview:nth-child(2)', text: news4.intro.to_plain_text), 'has correct intro'
      end
    end

    describe 'turbo-frame' do
      context 'when all params are set' do
        let(:params) { { order: :asc, per: 5, sort: :created_at } }

        it 'passes them to frames' do
          expect(page).to have_css('turbo-frame#news-by-month[src="/ru/frames/news/month?order=asc&per=5&sort=created_at"]')
          expect(page).to have_css('turbo-frame#news-by-tag[src="/ru/frames/news/tag?order=asc&per=5&sort=created_at"]')
        end
      end
    end

    describe 'language_component' do
      it_behaves_like 'shared language_component' do
        let(:link) { news_index_path(locale: 'en') }
      end
    end
  end

  describe '#by_tag' do
    before do
      visit by_tag_news_index_path(params)
    end

    describe 'index data query' do
      pending
    end

    describe 'search form should not preserve params (month, tag)' do
      pending
    end

    describe 'turbo-frame' do
      context 'when all params are set' do
        let(:params) { { tag: 'tag', order: :asc, per: 5, sort: :created_at } }

        it 'passes them to frames' do
          expect(page).to have_css('turbo-frame#news-by-month[src="/ru/frames/news/month?order=asc&per=5&sort=created_at"]')
          expect(page).to have_css('turbo-frame#news-by-tag[src="/ru/frames/news/tag?order=asc&per=5&sort=created_at&tag=tag"]')
        end
      end
    end

    describe 'language_component' do
      it_behaves_like 'shared language_component' do
        let(:params) { 'tag' }
        let(:link) { news_index_path(locale: 'en') }
      end
    end
  end

  describe '#by_month' do
    before do
      visit by_month_news_index_path(params)
    end

    describe 'data query' do
      pending
    end

    describe 'turbo-frame' do
      context 'when all params are set' do
        let(:params) { { month: '2020-04', order: :asc, per: 5, sort: :created_at } }

        it 'passes them to frames' do
          expect(page).to have_css('turbo-frame#news-by-month[src="/ru/frames/news/month?month=2020-04&order=asc&per=5&sort=created_at"]')
          expect(page).to have_css('turbo-frame#news-by-tag[src="/ru/frames/news/tag?order=asc&per=5&sort=created_at"]')
        end
      end
    end

    describe 'language_component' do
      it_behaves_like 'shared language_component' do
        let(:params) { '2020-04' }
        let(:link) { news_index_path(locale: 'en') }
      end
    end
  end
end
