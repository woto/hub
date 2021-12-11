# frozen_string_literal: true

require 'rails_helper'

describe 'Tables::ArticlesController#by_tag', type: :system, responsible: :admin do
  describe 'filter' do
    let!(:article) do
      create(:post, realm_kind: :news, tags: ['', 'tag1'], realm_locale: 'ru', status: :accrued_post)
    end

    before do
      switch_realm(article.realm) do
        visit articles_by_tag_path(tag: tag)
      end
    end

    context 'when tag is found' do
      let(:tag) { 'tag1' }

      it 'lists news with requested tag' do
        expect(page).to have_css('.articles-preview', text: article.intro.to_plain_text)
        expect(page).to have_css('.articles-preview', count: 1)
      end
    end

    context 'when tag is not found' do
      let(:tag) { 'tag2' }

      it 'does not list articles' do
        expect(page).to have_css('.articles-preview', count: 0)
      end
    end
  end

  describe 'articles-by-month turbo-frame' do
    before do
      switch_realm(Realm.pick(locale: :ru, kind: :news)) do
        visit articles_by_tag_path({ tag: 'tag1', order: :asc, per: 5, sort: :created_at })
      end
    end

    it 'passes query params to frame' do
      src = frames_articles_month_path(per: 5, sort: :created_at, order: :asc)
      frame = find('turbo-frame#articles-by-month')
      expect(frame['src']).to end_with(src)
    end
  end

  describe 'articles-by-tag turbo-frame' do
    before do
      switch_realm(Realm.pick(locale: :ru, kind: :news)) do
        visit articles_by_tag_path({ tag: 'tag1', order: :asc, per: 5, sort: :created_at })
      end
    end

    it 'passes query params to frame' do
      src = frames_articles_tag_path(tag: 'tag1', per: 5, sort: :created_at, order: :asc)
      frame = find('turbo-frame#articles-by-tag')
      expect(frame['src']).to end_with(src)
    end
  end

  describe 'articles-by-category turbo-frame' do
    before do
      switch_realm(Realm.pick(locale: :ru, kind: :news)) do
        visit articles_by_tag_path({ tag: 'tag1', order: :asc, per: 5, sort: :created_at })
      end
    end

    it 'passes query params to frame' do
      src = frames_articles_category_path(per: 5, sort: :created_at, order: :asc)
      frame = find('turbo-frame#articles-by-category')
      expect(frame['src']).to end_with(src)
    end
  end
end
