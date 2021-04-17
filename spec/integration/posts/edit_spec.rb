# frozen_string_literal: true

require 'rails_helper'

describe Tables::PostsController, type: :system do
  describe 'shared_language_component' do
    it_behaves_like 'shared_language_component' do
      before do
        login_as(user, scope: :user)
        visit edit_post_path(post, locale: 'ru')
      end

      let(:user) { create(:user, role: :admin) }

      let(:post) do
        Current.set(responsible: user) do
          create(:post, user: user)
        end
      end

      let(:link) { edit_post_path(post, locale: 'en') }
    end
  end

  describe 'shared_search_everywhere' do
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
        { controller: 'posts', q: q, cols: '0.6.5.16.13', locale: 'ru',
          per: 20, sort: :id, order: :desc, only_path: true }
      end
    end
  end
end
