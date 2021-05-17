# frozen_string_literal: true

require 'rails_helper'

describe Tables::TransactionsController, type: :system, responsible: :admin do
  describe 'GET /transactions' do
    it_behaves_like 'favorites_initial_starred' do
      before do
        favorite = create(:favorite, user: Current.responsible, kind: 'transactions')
        create(:favorites_item, ext_id: starred_object.id, kind: 'transactions', favorite: favorite)
        login_as(Current.responsible, scope: :user)
        visit transactions_path
      end

      let(:starred) { "favorite-transactions-#{starred_object.id}" }
      let(:starred_object) { create(:transaction) }
    end

    it_behaves_like 'favorites_initial_unstarred' do
      before do
        login_as(Current.responsible, scope: :user)
        visit transactions_path
      end

      let(:unstarred) { "favorite-transactions-#{unstarred_object.id}" }
      let(:unstarred_object) { create(:transaction) }
    end
  end
end
