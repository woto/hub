# frozen_string_literal: true

require 'rails_helper'

describe Tables::PostsController, type: :system do
  describe 'GET /posts/:id/edit' do
    it_behaves_like 'shared_search_everywhere' do
      before do
        user = create(:user)
        post = Current.set(responsible: user) do
          create(:post, user: user)
        end
        login_as(user, scope: :user)
        visit "/ru/posts/#{post.id}/edit"
      end

      let(:params) do
        { controller: 'posts', q: q, cols: '0.7.6.28.27.24.25', locale: 'ru',
          per: 20, sort: :id, order: :desc, only_path: true }
      end
    end
  end

  describe 'GET /posts' do
    it_behaves_like 'shared_search_everywhere' do
      before do
        user = create(:user)
        Current.set(responsible: user) do
          create(:post, user: user)
        end
        login_as(user, scope: :user)
        visit '/ru/posts'
      end

      let(:params) do
        { controller: 'tables/posts', q: q, cols: '0.7.6.28.27.24.25', locale: 'ru',
          per: 20, sort: :id, order: :desc, only_path: true }
      end
    end
  end
end
