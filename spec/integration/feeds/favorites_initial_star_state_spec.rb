# frozen_string_literal: true

require 'rails_helper'

describe Tables::FeedsController, type: :system, responsible: :admin do
  describe 'GET /feeds' do
    it_behaves_like 'favorites_initial_starred' do
      before do
        favorite = create(:favorite, user: Current.responsible, kind: 'feeds')
        create(:favorites_item, ext_id: starred_object.id, kind: 'feeds', favorite: favorite)
        login_as(Current.responsible, scope: :user)
        visit feeds_path
      end

      let(:starred) { "favorite-feeds-#{starred_object.id}" }
      let(:starred_object) { create(:feed) }
    end

    it_behaves_like 'favorites_initial_unstarred' do
      before do
        visit feeds_path
      end

      let(:unstarred) { "favorite-feeds-#{unstarred_object.id}" }
      let(:unstarred_object) { create(:feed) }
    end
  end
end

