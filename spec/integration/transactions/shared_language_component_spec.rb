# frozen_string_literal: true

require 'rails_helper'

describe Tables::TransactionsController, type: :system do
  describe 'GET /transactions' do
    it_behaves_like 'shared_language_component' do
      before do
        login_as(user, scope: :user)
        visit transactions_path
      end

      let!(:user) { create(:user) }
      let(:link) { transactions_path(locale: 'en') }
    end
  end
end
