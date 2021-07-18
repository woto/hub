# frozen_string_literal: true

require 'rails_helper'

describe 'Tables::ArticlesController#by_month', type: :system, responsible: :admin do
  describe 'filter' do
    let!(:article1) do
      create(:post, realm_kind: :news, realm_locale: :ru, published_at: Time.zone.parse('2020-01-01'),
                    status: :accrued_post)
    end
    let!(:article2) do
      create(:post, realm_kind: :news, realm_locale: :ru, published_at: Time.zone.parse('2019-01-01'),
                    status: :accrued_post)
    end

    context 'when requested month is `2020-01`' do
      before do
        switch_realm(article1.realm) do
          visit articles_by_month_path(month: '2020-01')
        end
      end

      it 'shows only article1' do
        expect(page).to have_css('.articles-preview', text: article1.intro.to_plain_text)
        expect(page).to have_css('.articles-preview', count: 1)
      end
    end

    context 'when requested month is `2019-01`' do
      before do
        switch_realm(article2.realm) do
          visit articles_by_month_path(month: '2019-01')
        end
      end

      it 'shows only article2' do
        expect(page).to have_css('.articles-preview', text: article2.intro.to_plain_text)
        expect(page).to have_css('.articles-preview', count: 1)
      end
    end

    describe 'article visibility by publication time' do
      let(:article) { create(:post, realm_kind: :news, published_at: published_at, status: :accrued_post) }

      before do
        switch_realm(article.realm) do
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
        switch_realm(article1.realm) do
          visit articles_by_month_path(month: '2020-04', order: :asc, per: 5, sort: :created_at)
        end
      end

      it 'passes query params to frame' do
        src = frames_articles_month_path(month: '2020-04', order: :asc, per: 5, sort: :created_at)
        expect(page).to have_css("turbo-frame#articles-by-month[src='#{src}']")
      end
    end
  end

  describe 'articles-by-tag turbo-frame' do
    before do
      switch_realm(create(:realm)) do
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
      switch_realm(create(:realm)) do
        visit articles_by_month_path({ month: '2020-04', order: :asc, per: 5, sort: :created_at })
      end
    end

    it 'passes query params to frame' do
      src = frames_articles_category_path(per: 5, sort: :created_at, order: :asc)
      expect(page).to have_css("turbo-frame#articles-by-category[src='#{src}']")
    end
  end
end
