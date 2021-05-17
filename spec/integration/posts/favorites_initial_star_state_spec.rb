# frozen_string_literal: true

require 'rails_helper'

describe Tables::PostsController, type: :system, responsible: :admin do
  describe 'GET /posts' do
    it_behaves_like 'favorites_initial_starred' do
      before do
        favorite = create(:favorite, user: Current.responsible, kind: 'posts')
        create(:favorites_item, ext_id: starred_object.id, kind: 'posts', favorite: favorite)
        login_as(Current.responsible, scope: :user)
        visit posts_path
      end

      let(:starred) { "favorite-posts-#{starred_object.id}" }
      let(:starred_object) { create(:post) }
    end

    it_behaves_like 'favorites_initial_unstarred' do
      before do
        login_as(Current.responsible, scope: :user)
        visit posts_path
      end

      let(:unstarred) { "favorite-posts-#{unstarred_object.id}" }
      let(:unstarred_object) { create(:post) }
    end
  end
end
