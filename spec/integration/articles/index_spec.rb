# frozen_string_literal: true

require 'rails_helper'

describe 'Tables::ArticlesController#index', type: :system, responsible: :admin do
  context 'when article is present' do
    let!(:article) { create(:post, realm_kind: :news, status: :accrued_post) }

    before do
      switch_domain(article.realm.domain) do
        visit articles_path
      end
    end

    it 'shows realm title' do
      expect(page).to have_css('h1', text: article.realm.to_label)
    end

    it 'shows article title' do
      expect(page).to have_css('h2', text: article.title)
    end

    it 'wraps article.intro in selector' do
      expect(page).to have_css('.articles-preview', text: article.intro.to_plain_text)
    end
  end

  context 'when params partially present in request' do
    let(:realm) { create(:realm, locale: :ru) }

    before do
      switch_domain(realm.domain) do
        visit articles_path(per: 1)
      end
    end

    it 'partially uses params in new location path' do
      expect(page).to have_current_path(articles_path(host: realm.domain, per: 1))
    end
  end

  context 'when params is empty' do
    before do
      switch_domain(Realm.pick(locale: :ru, kind: :news).domain) do
        visit articles_path
      end
    end

    it 'redirects to system workspace' do
      expect(page).to have_current_path(articles_path)
    end
  end

  context 'when "per" param is 1 and "page" is 2' do
    before do
      post = create(:post, realm_kind: :news, realm_locale: :ru, status: :accrued_post)
      create(:post, realm_kind: :news, realm_locale: :ru, status: :accrued_post)
      switch_domain(post.realm.domain) do
        visit articles_path(per: 1, page: 2, locale: 'ru')
      end
    end

    it 'lists one article of two' do
      expect(page).to have_css('h2', count: 1)
      expect(page).to have_text('Отображение 2 - 2 из 2 всего')
    end
  end

  describe 'pagination' do
    before do
      create(:post, realm_kind: :news, realm_locale: :ru, status: :accrued_post)
      create(:post, realm_kind: :news, realm_locale: :ru, status: :accrued_post)
    end

    it 'shows pagination' do
      switch_domain(Realm.pick(locale: :ru, kind: :news).domain) do
        visit articles_path(per: 1)
      end
      expect(page).to have_css('.pagination')
    end
  end

  describe 'article visibility by publication time' do
    let(:article) { create(:post, realm_kind: :news, published_at: published_at, status: :accrued_post) }

    before do
      switch_domain(article.realm.domain) do
        visit articles_by_month_path(
                month: ApplicationController.helpers.l(published_at, format: '%Y-%m')
              )
      end
    end

    shared_examples 'published_at visibility' do |count|
      it 'shows or hides article' do
        expect(page).to have_css('.articles-preview', count: count)
      end
    end

    context 'when publication time has not yet come' do
      let(:published_at) { 1.hour.after }

      it_behaves_like 'published_at visibility', 0
    end

    context 'when publication time already come' do
      let(:published_at) { 1.hour.before }

      it_behaves_like 'published_at visibility', 1
    end
  end

  describe 'articles-by-month turbo-frame' do
    before do
      switch_domain(Realm.pick(locale: :ru, kind: :news).domain) do
        visit articles_path({ order: :asc, per: 5, sort: :created_at, locale: 'ru' })
      end
    end

    it 'passes query params to frame' do
      src = frames_articles_month_path(order: :asc, per: 5, sort: :created_at)
      expect(page).to have_css("turbo-frame#articles-by-month[src='#{src}']", visible: :all)
    end
  end

  describe 'articles-by-tag turbo-frame' do
    before do
      switch_domain(Realm.pick(locale: :ru, kind: :news).domain) do
        visit articles_path({ order: :asc, per: 5, sort: :created_at, locale: 'ru' })
      end
    end

    it 'passes query params to frame' do
      src = frames_articles_month_path(order: :asc, per: 5, sort: :created_at)
      expect(page).to have_css("turbo-frame#articles-by-month[src='#{src}']", visible: :all)
    end
  end

  describe 'articles-by-category turbo-frame' do
    before do
      switch_domain(Realm.pick(locale: :ru, kind: :news).domain) do
        visit articles_path({ order: :asc, per: 5, sort: :created_at, locale: 'ru' })
      end
    end

    it 'has correct articles-by-category turbo-frame' do
      src = frames_articles_category_path(per: 5, sort: :created_at, order: :asc)
      expect(page).to have_css("turbo-frame#articles-by-category[src='#{src}']", visible: :all)
    end
  end
end
