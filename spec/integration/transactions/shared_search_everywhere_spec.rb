# frozen_string_literal: true

require 'rails_helper'

describe Tables::TransactionsController, type: :system do
  describe 'GET /transactions' do
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
        { controller: 'tables/transactions', q: q, cols: '0.3.6.8.9.11.12.15.16', locale: 'ru',
          per: 20, sort: :id, order: :desc, only_path: true }
      end
    end
  end
end
