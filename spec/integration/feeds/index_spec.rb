# frozen_string_literal: true

require 'rails_helper'

describe Tables::FeedsController, type: :system do
  describe 'shared_language_component' do
    it_behaves_like 'shared_language_component' do
      before do
        visit feeds_path
      end

      let(:link) { feeds_path(locale: 'en') }
    end
  end

  describe 'shared_search_everywhere' do
    it_behaves_like 'shared_search_everywhere' do
      before do
        user = create(:user, role: :admin)
        create(:feed)
        login_as(user, scope: :user)
        visit '/ru/feeds'
      end

      let(:params) do
        { controller: 'tables/feeds', q: q, cols: '0.26.3.15.21.22', locale: 'ru',
          per: 20, sort: :id, order: :desc, only_path: true }
      end
    end
  end

  describe '#index' do
    describe 'TODO' do
      describe 'shared_table' do
        it_behaves_like 'shared_table' do
          let(:objects) { create_list(singular, 11) }
          let(:plural) { 'feeds' }
          let(:singular) { 'feed' }
        end
      end

      describe 'shared_workspace_unauthenticated' do
        it_behaves_like 'shared_workspace_unauthenticated' do
          before do
            create(:feed)
            visit '/ru/feeds'
          end
        end
      end

      describe 'shared_workspace_authenticated' do
        it_behaves_like 'shared_workspace_authenticated' do
          let(:cols) { '0.30.3' }
          let(:plural) { 'feeds' }
          let(:user) { create(:user) }
        end
      end

      describe 'shared_favorites_unauthenticated' do
        it_behaves_like 'shared_favorites_unauthenticated' do
          before do
            feed = create(:feed)
            visit '/ru/feeds'
            click_on("favorite-#{feed.id}")
          end
        end
      end
    end
  end
end
