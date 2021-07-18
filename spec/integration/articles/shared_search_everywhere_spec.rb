# frozen_string_literal: true

require 'rails_helper'

describe Tables::ArticlesController, type: :system do

  describe 'GET /articles/month/:month' do
    it_behaves_like 'shared_search_everywhere' do
      before do
        switch_realm(create(:realm, key: :ru)) do
          visit articles_by_month_path('2020-12')
        end
      end

      let(:params) do
        { controller: 'tables/articles', q: q, per: 20, sort: :published_at, order: :desc, only_path: true }
      end
    end
  end

  describe 'GET /articles/tag/:tag' do
    it_behaves_like 'shared_search_everywhere' do
      before do
        switch_realm(create(:realm, key: :ru)) do
          visit articles_by_tag_path(tag: 'money')
        end
      end

      let(:params) do
        { controller: 'tables/articles', q: q, per: 20, sort: :published_at, order: :desc, only_path: true }
      end
    end
  end

  describe 'GET /articles' do
    it_behaves_like 'shared_search_everywhere' do
      before do
        switch_realm(create(:realm, key: :ru)) do
          visit articles_path
        end
      end

      let(:params) do
        { controller: 'tables/articles', q: q, per: 20, sort: :published_at, order: :desc, only_path: true }
      end
    end
  end

  describe 'GET /articles/:id' do
    it_behaves_like 'shared_search_everywhere' do
      let(:realm) { create(:realm, key: :ru) }
      let(:article) { create(:post, realm: realm, post_category: create(:post_category, realm: realm)) }

      before do
        switch_realm(realm) do
          visit article_path(article)
        end
      end

      let(:params) do
        { controller: 'tables/articles', q: q, per: 20, sort: :published_at, order: :desc, only_path: true }
      end
    end
  end
end
