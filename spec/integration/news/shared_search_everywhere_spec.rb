# frozen_string_literal: true

require 'rails_helper'

describe Tables::NewsController, type: :system do

  describe 'GET /news/month/:month' do
    it_behaves_like 'shared_search_everywhere' do
      before do
        visit '/ru/news/month/2020-12'
      end

      let(:params) do
        { controller: 'tables/news', q: q, locale: 'ru', per: 20, sort: :published_at, order: :desc,
          only_path: true }
      end
    end
  end

  describe 'GET /news/tag/:tag' do
    it_behaves_like 'shared_search_everywhere' do
      before do
        visit '/ru/news/tag/money'
      end

      let(:params) do
        { controller: 'tables/news', q: q, locale: 'ru', per: 20, sort: :published_at, order: :desc,
          only_path: true }
      end
    end
  end

  describe 'GET /news' do
    it_behaves_like 'shared_search_everywhere' do
      before do
        visit '/ru/news'
      end

      let(:params) do
        { controller: 'tables/news', q: q, locale: 'ru', per: 20, sort: :published_at, order: :desc,
          only_path: true }
      end
    end
  end

  describe 'GET /news/:id' do
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
end
