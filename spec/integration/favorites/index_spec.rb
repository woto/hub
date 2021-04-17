# frozen_string_literal: true

require 'rails_helper'

describe Tables::FavoritesController, type: :system do
  describe 'shared_language_component' do
    it_behaves_like 'shared_language_component' do
      before do
        login_as(user, scope: :user)
        visit favorites_path
      end

      let!(:user) { create(:user) }
      let(:link) { favorites_path(locale: 'en') }
    end
  end

  describe 'shared_search_everywhere' do
    it_behaves_like 'shared_search_everywhere' do
      before do
        user = create(:user, role: :admin)
        create(:favorite)
        login_as(user, scope: :user)
        visit '/ru/favorites'
      end

      let(:params) do
        { controller: 'tables/favorites', q: q, cols: '0.1.2.3', locale: 'ru',
          per: 20, sort: :id, order: :desc, only_path: true }
      end
    end
  end

  describe '#index' do
    describe 'TODO' do
      describe 'shared_table' do
        it_behaves_like 'shared_table' do
          let(:objects) do
            create_list(singular, 11, user: user)
          end
          let(:plural) { 'favorites' }
          let(:singular) { 'favorite' }
          let!(:user) { create(:user) }

          before do
            login_as(user, scope: :user)
          end
        end
      end

      describe 'shared_workspace_authenticated' do
        it_behaves_like 'shared_workspace_authenticated' do
          let(:cols) { '0.30.3' }
          let(:plural) { 'favorites' }
          let(:user) { create(:user) }
        end
      end
    end
  end
end
