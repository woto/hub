# frozen_string_literal: true

require 'rails_helper'

describe Tables::TransactionsController, type: :system do
  describe 'shared_language_component' do
    it_behaves_like 'shared_language_component' do
      before do
        login_as(user, scope: :user)
        visit transactions_path
      end

      let!(:user) { create(:user) }
      let(:link) { transactions_path(locale: 'en') }
    end
  end

  describe 'shared_search_everywhere' do
    it_behaves_like 'shared_search_everywhere' do
      before do
        user = create(:user)
        Current.set(responsible: user) do
          create(:post, user: user)
        end
        login_as(user, scope: :user)
        visit '/ru/transactions'
      end

      let(:params) do
        { controller: 'tables/transactions', q: q, cols: '0.2.1.12.9.8.19.17.15.14.21.22', locale: 'ru',
          per: 20, sort: :id, order: :desc, only_path: true }
      end
    end
  end

  describe '#index' do
    describe 'TODO' do
      describe 'shared_table' do
        it_behaves_like 'shared_table' do
          let(:objects) do
            objects = []
            11.times do
              Current.set(responsible: user) do
                Accounting::Actions::StakeholderToHub.call(
                  stakeholder_payed: Account.stakeholder_payed_rub,
                  hub_payed: Account.hub_payed_rub,
                  amount: 50_000.to_d,
                  group: group
                )
                objects.append(Transaction.last)
              end
            end
            objects
          end
          let(:plural) { 'transactions' }
          let(:singular) { 'transaction' }
          let!(:user) { create(:user, role: :admin) }
          let(:group) { create(:transaction_group) }

          before do
            login_as(user, scope: :user)
          end
        end
      end

      describe 'shared_workspace_authenticated' do
        it_behaves_like 'shared_workspace_authenticated' do
          let(:plural) { 'transactions' }
          let!(:user) { create(:user, role: 'admin') }
          let(:cols) { '0.6.5.16.13' }
        end
      end
    end
  end
end
