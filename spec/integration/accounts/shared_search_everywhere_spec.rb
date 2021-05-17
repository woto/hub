# frozen_string_literal: true

require 'rails_helper'

describe Tables::AccountsController, type: :system do
  describe 'GET /accounts' do
    it_behaves_like 'shared_search_everywhere' do
      before do
        Account.for_subject(:hub, :pending, :usd)
        user = create(:user, role: :admin)
        login_as(user, scope: :user)
        visit '/ru/accounts'
      end

      let(:params) do
        { controller: 'tables/accounts', q: q, cols: '0.6.3.1.4.5.7.8', locale: 'ru',
          per: 20, sort: :id, order: :desc, only_path: true }
      end
    end
  end
end
