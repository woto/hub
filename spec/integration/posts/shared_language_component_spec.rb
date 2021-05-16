# frozen_string_literal: true

require 'rails_helper'

describe Tables::PostsController, type: :system do
  describe 'GET /posts/:id/edit' do
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

  describe 'GET /posts' do
    it_behaves_like 'shared_language_component' do
      before do
        login_as(user, scope: :user)
        visit posts_path
      end

      let(:user) { create(:user) }
      let(:link) { posts_path(locale: 'en') }
    end
  end
end
