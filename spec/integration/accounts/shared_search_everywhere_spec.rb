# frozen_string_literal: true

require 'rails_helper'

describe 'Accounts shared search everywhere', type: :system do
  describe 'GET /accounts' do
    it_behaves_like 'shared_search_everywhere' do
      before do
        Account.for_subject(:hub, :pending_post, :usd)
        user = create(:user, role: :admin)
        login_as(user, scope: :user)
        visit '/ru/accounts'
      end

      let(:params) do
        { controller: 'tables/accounts', q: q, locale: 'ru', only_path: true }
      end
    end
  end
end
