# frozen_string_literal: true

require 'rails_helper'

describe 'Posts shared search everywhere', type: :system do
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
        { controller: 'posts', q: q, columns: %w[id title post_category status amount user_id created_at updated_at],
          locale: 'ru', per: 20, sort: :id, order: :desc, only_path: true }
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
        { controller: 'tables/posts', q: q,
          columns: %w[id title post_category status amount user_id created_at updated_at], locale: 'ru',
          per: 20, sort: :id, order: :desc, only_path: true }
      end
    end
  end
end
