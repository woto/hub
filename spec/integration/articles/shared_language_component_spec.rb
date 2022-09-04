# frozen_string_literal: true

require 'rails_helper'

describe 'Tables::ArticlesController shared_language_component', type: :system do

  SELECTOR = "[data-test-id='language-component']"

  context 'when kind is news' do
    let!(:realm) { create(:realm, locale: :'en-US', kind: :news) }

    describe 'GET /articles/month/:month' do
      it_behaves_like 'shared_language_component' do
        before do
          switch_domain(Realm.pick(locale: :ru, kind: :news).domain) do
            visit articles_by_month_path('2020-04')
          end
        end

        let(:link) { articles_url(host: realm.domain, port: Capybara.current_session.server.port) }

        it 'contains link to switch language' do
          expect(page).to have_css(SELECTOR)
        end
      end
    end

    describe 'GET /articles/tag/:tag' do
      it_behaves_like 'shared_language_component' do
        before do
          switch_domain(Realm.pick(locale: :ru, kind: :news).domain) do
            visit articles_by_tag_path(tag: 'tag')
          end
        end

        let(:link) { articles_url(host: realm.domain, port: Capybara.current_session.server.port) }

        it 'contains link to switch language' do
          expect(page).to have_css(SELECTOR)
        end
      end
    end

    describe 'GET /articles' do
      it_behaves_like 'shared_language_component' do
        before do
          switch_domain(Realm.pick(locale: :ru, kind: :news).domain) do
            visit articles_path
          end
        end

        let(:link) { articles_url(host: realm.domain, port: Capybara.current_session.server.port) }

        it 'contains link to switch language' do
          expect(page).to have_css(SELECTOR)
        end
      end
    end
  end

  context 'when kind is post' do
    let!(:realm) { create(:realm, kind: :post) }

    describe 'GET /articles/month/:month' do
      before do
        switch_domain(realm.domain) do
          visit articles_by_month_path('2020-04')
        end
      end

      it 'does not contain link to switch language' do
        expect(page).not_to have_css(SELECTOR)
      end
    end

    describe 'GET /articles/tag/:tag' do
      before do
        switch_domain(realm.domain) do
          visit articles_by_tag_path(tag: 'tag')
        end
      end

      it 'does not contain link to switch language' do
        expect(page).not_to have_css(SELECTOR)
      end
    end

    describe 'GET /articles' do
      before do
        switch_domain(realm.domain) do
          visit articles_path
        end
      end

      it 'does not contain link to switch language' do
        expect(page).not_to have_css(SELECTOR)
      end
    end
  end

end
