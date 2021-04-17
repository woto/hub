# frozen_string_literal: true

require 'rails_helper'

describe Tables::AccountsController, type: :system do
  describe 'shared_language_component' do
    it_behaves_like 'shared_language_component' do
      before do
        login_as(user, scope: :user)
        visit accounts_path
      end

      let!(:user) { create(:user, role: 'admin') }
      let(:link) { accounts_path(locale: 'en') }
    end
  end

  describe 'shared_search_everywhere' do
    it_behaves_like 'shared_search_everywhere' do
      before do
        Account.hub_pending_usd
        user = create(:user, role: :admin)
        login_as(user, scope: :user)
        visit '/ru/accounts'
      end

      let(:params) do
        { controller: 'tables/accounts', q: q, cols: '0.9.6.4.5.1.2.3.7.8.10.11', locale: 'ru',
          per: 20, sort: :id, order: :desc, only_path: true }
      end
    end
  end

  describe '#index' do
    describe 'TODO' do
      describe 'shared_table' do
        it_behaves_like 'shared_table' do
          let(:objects) do
            admin = create(:user, role: :admin)
            Current.set(responsible: admin) do
              create_list(singular, 11, :for_account_group)
            end
          end
          let(:plural) { 'accounts' }
          let(:singular) { 'account' }
          let(:user) { create(:user, role: :admin) }

          before do
            login_as(user, scope: :user)
          end
        end
      end

      describe 'shared_workspace_authenticated' do
        it_behaves_like 'shared_workspace_authenticated' do
          let(:cols) { '0.30.3' }
          let(:plural) { 'accounts' }
          let(:user) { create(:user) }
        end
      end

      describe 'favorites_preload_stars' do
        it_behaves_like 'favorites_preload_stars' do
          before do
            user = create(:user, role: :admin)
            login_as(user, scope: :user)
          end

          let!(:starred) { Account.hub_pending_usd }
          let!(:unstarred) { Account.hub_pending_rub }
        end
      end
    end
  end
end
