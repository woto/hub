# frozen_string_literal: true

require 'rails_helper'

describe 'Tables::ArticlesController#by_category', type: :system, responsible: :admin do
  describe 'filter' do
    let!(:article) { create(:post, post_category: post_category, realm: realm, status: :accrued_post) }
    let(:realm) { Realm.pick(locale: :ru, kind: :news) }
    let(:post_category) { create(:post_category, realm: realm) }

    before do
      switch_domain(Realm.pick(locale: :ru, kind: :news).domain) do
        visit articles_by_category_path(category_id: category_id)
      end
    end

    context 'when post is in the requested category' do
      let(:category_id) { post_category.id }

      it 'shows article' do
        expect(page).to have_css('.articles-preview', text: article.intro.to_plain_text)
        expect(page).to have_css('.articles-preview', count: 1)
      end
    end

    context 'when post is not in the requested category' do
      let(:category_id) { create(:post_category).id }

      it 'does not show article' do
        expect(page).to have_css('.articles-preview', count: 0)
      end
    end
  end

  describe 'articles-by-month turbo-frame' do
    let(:post_category) { create(:post_category) }

    before do
      switch_domain(Realm.pick(locale: :ru, kind: :news).domain) do
        visit articles_by_category_path({ category_id: post_category.id, order: :asc, per: 5, sort: :created_at })
      end
    end

    it 'passes query params to frame' do
      src = frames_articles_month_path(per: 5, sort: :created_at, order: :asc)
      frame = find('turbo-frame#articles-by-month')
      expect(frame['src']).to end_with(src)
    end
  end

  describe 'articles-by-tag turbo-frame' do
    let(:post_category) { create(:post_category) }

    before do
      switch_domain(Realm.pick(locale: :ru, kind: :news).domain) do
        visit articles_by_category_path({ category_id: post_category.id, order: :asc, per: 5, sort: :created_at })
      end
    end

    it 'passes query params to frame' do
      src = frames_articles_tag_path(per: 5, sort: :created_at, order: :asc)
      frame = find('turbo-frame#articles-by-tag')
      expect(frame['src']).to end_with(src)
    end
  end

  describe 'articles-by-category turbo-frame' do
    let(:post_category) { create(:post_category) }

    before do
      switch_domain(Realm.pick(locale: :ru, kind: :news).domain) do
        visit articles_by_category_path({ category_id: post_category.id, order: :asc, per: 5, sort: :created_at })
      end
    end

    it 'passes query params to frame' do
      src = frames_articles_category_path(category_id: post_category.id, per: 5, sort: :created_at, order: :asc)
      frame = find('turbo-frame#articles-by-category')
      expect(frame['src']).to end_with(src)
    end
  end
end
