# frozen_string_literal: true

require 'rails_helper'

describe 'Transactions shared search everywhere', type: :system do
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
        { controller: 'tables/transactions', q: q, locale: 'ru', only_path: true }
      end
    end
  end
end
