# frozen_string_literal: true

require 'rails_helper'

describe Tables::AccountsController, type: :system, responsible: :admin do
  describe 'GET /accounts' do
    it_behaves_like 'favorites_initial_starred' do
      before do
        favorite = create(:favorite, user: Current.responsible, kind: 'accounts')
        create(:favorites_item, ext_id: starred_object.id, kind: 'accounts', favorite: favorite)
        login_as(Current.responsible, scope: :user)
        visit accounts_path
      end

      let(:starred) { "favorite-accounts-#{starred_object.id}" }
      let(:starred_object) { Account.for_subject(:hub, :pending, :usd) }
    end

    it_behaves_like 'favorites_initial_unstarred' do
      before do
        login_as(Current.responsible, scope: :user)
        visit accounts_path
      end

      let(:unstarred) { "favorite-accounts-#{unstarred_object.id}" }
      let(:unstarred_object) { Account.for_user(Current.responsible, :pending, :rub) }
    end
  end
end
