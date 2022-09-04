# frozen_string_literal: true

require 'rails_helper'

describe 'Articles shared search everywhere', type: :system do
  describe 'GET /articles/month/:month' do
    it_behaves_like 'shared_search_everywhere' do
      before do
        switch_domain(Realm.pick(locale: :ru, kind: :news).domain) do
          visit articles_by_month_path('2020-12')
        end
      end

      let(:params) do
        { controller: 'tables/articles', q: q, only_path: true }
      end
    end
  end

  describe 'GET /articles/tag/:tag' do
    it_behaves_like 'shared_search_everywhere' do
      before do
        switch_domain(Realm.pick(locale: :ru, kind: :news).domain) do
          visit articles_by_tag_path(tag: 'money')
        end
      end

      let(:params) do
        { controller: 'tables/articles', q: q, only_path: true }
      end
    end
  end

  describe 'GET /articles' do
    it_behaves_like 'shared_search_everywhere' do
      before do
        switch_domain(Realm.pick(locale: :ru, kind: :news).domain) do
          visit articles_path
        end
      end

      let(:params) do
        { controller: 'tables/articles', q: q, only_path: true }
      end
    end
  end

  describe 'GET /articles/:id' do
    it_behaves_like 'shared_search_everywhere' do
      let(:realm) { create(:realm, locale: :ru) }
      let(:article) do
        create(:post, realm: realm, post_category: create(:post_category, realm: realm), status: :accrued_post)
      end

      before do
        switch_domain(realm.domain) do
          visit article_path(article)
        end
      end

      let(:params) do
        { controller: 'tables/articles', q: q, only_path: true }
      end
    end
  end
end
