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
        { controller: 'tables/transactions', q: q,
          columns: %w[id transaction_group_id code credit_label credit_amount debit_label debit_amount created_at updated_at],
          locale: 'ru', per: 20, sort: :id, order: :desc, only_path: true }
      end
    end
  end
end
