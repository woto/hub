# frozen_string_literal: true

require 'rails_helper'

describe Tables::TransactionsController, type: :system do
  describe 'shared_table' do
    it_behaves_like 'shared_table' do
      let(:objects) do
        Current.set(responsible: user) do
          FactoryBot.create_list(:transaction, 11, user: user)
        end
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
end
