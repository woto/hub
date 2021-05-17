# frozen_string_literal: true

require 'rails_helper'

describe Tables::UsersController, type: :system, responsible: :admin do
  describe 'GET /users' do
    it_behaves_like 'favorites_initial_starred' do
      before do
        favorite = create(:favorite, user: Current.responsible, kind: 'users')
        create(:favorites_item, ext_id: starred_object.id, kind: 'users', favorite: favorite)
        login_as(Current.responsible, scope: :user)
        visit users_path
      end

      let(:starred) { "favorite-users-#{starred_object.id}" }
      let(:starred_object) { create(:user) }
    end

    it_behaves_like 'favorites_initial_unstarred' do
      before do
        login_as(Current.responsible, scope: :user)
        visit users_path
      end

      let(:unstarred) { "favorite-users-#{unstarred_object.id}" }
      let(:unstarred_object) { create(:user) }
    end
  end
end
