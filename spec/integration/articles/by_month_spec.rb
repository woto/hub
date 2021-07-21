# frozen_string_literal: true

require 'rails_helper'

describe 'Tables::ArticlesController#by_month', type: :system, responsible: :admin do
  describe 'filter' do
    let!(:article1) do
      create(:post, realm_locale: :ru, realm_kind: :news, published_at: Time.zone.parse('2020-01-01'),
             status: :accrued_post)
    end
    let!(:article2) do
      create(:post, realm_locale: :ru, realm_kind: :news, published_at: Time.zone.parse('2019-01-01'),
             status: :accrued_post)
    end

    before do
      switch_realm(Realm.pick(locale: :ru, kind: :news)) do
        visit articles_by_month_path(month: month)
      end
    end

    context 'when requested month is `2020-01`' do
      let(:month) { '2020-01' }

      it 'shows only article1' do
        expect(page).to have_css('.articles-preview', text: article1.intro.to_plain_text)
        expect(page).to have_css('.articles-preview', count: 1)
      end
    end

    context 'when requested month is `2019-01`' do
      let(:month) { '2019-01' }

      it 'shows only article2' do
        expect(page).to have_css('.articles-preview', text: article2.intro.to_plain_text)
        expect(page).to have_css('.articles-preview', count: 1)
      end
    end
  end

  describe 'articles-by-month turbo-frame' do
    before do
      switch_realm(Realm.pick(locale: :ru, kind: :news)) do
        visit articles_by_month_path(month: '2020-04', order: :asc, per: 5, sort: :created_at)
      end
    end

    it 'passes query params to frame' do
      src = frames_articles_month_path(month: '2020-04', order: :asc, per: 5, sort: :created_at)
      expect(page).to have_css("turbo-frame#articles-by-month[src='#{src}']")
    end
  end

  describe 'articles-by-tag turbo-frame' do
    before do
      switch_realm(Realm.pick(locale: :ru, kind: :news)) do
        visit articles_by_month_path({ month: '2020-04', order: :asc, per: 5, sort: :created_at })
      end
    end

    it 'passes query params to frame' do
      src = frames_articles_tag_path(per: 5, sort: :created_at, order: :asc)
      expect(page).to have_css("turbo-frame#articles-by-tag[src='#{src}']")
    end
  end

  describe 'articles-by-category turbo-frame' do
    before do
      switch_realm(Realm.pick(locale: :ru, kind: :news)) do
        visit articles_by_month_path({ month: '2020-04', order: :asc, per: 5, sort: :created_at })
      end
    end

    it 'passes query params to frame' do
      src = frames_articles_category_path(per: 5, sort: :created_at, order: :asc)
      expect(page).to have_css("turbo-frame#articles-by-category[src='#{src}']")
    end
  end
end
