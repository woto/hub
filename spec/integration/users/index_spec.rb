# frozen_string_literal: true

require 'rails_helper'

describe Tables::UsersController, type: :system do
  describe 'shared_language_component' do
    it_behaves_like 'shared_language_component' do
      before do
        login_as(user, scope: :user)
        visit users_path
      end

      let!(:user) { create(:user, role: 'admin') }
      let(:link) { users_path(locale: 'en') }
    end
  end

  describe 'shared_search_everywhere' do
    it_behaves_like 'shared_search_everywhere' do
      before do
        user = create(:user, role: :admin)
        login_as(user, scope: :user)
        visit '/ru/users'
      end

      let(:params) do
        { controller: 'tables/users', q: q, cols: '0.6', locale: 'ru',
          per: 20, sort: :id, order: :desc, only_path: true }
      end
    end
  end

  describe '#index' do
    describe 'TODO' do
      describe 'shared_table' do
        it_behaves_like 'shared_table' do
          let(:objects) { create_list(singular, 10) }
          let(:plural) { 'users' }
          let(:singular) { 'user' }
          let!(:user) { create(:user, role: 'admin') }

          before do
            login_as(user, scope: :user)
          end
        end
      end

      describe 'shared_workspace_authenticated' do
        it_behaves_like 'shared_workspace_authenticated' do
          let(:plural) { 'users' }
          let!(:user) { create(:user, role: 'admin') }
          let(:cols) { '0.6' }
        end
      end
    end
  end
end
