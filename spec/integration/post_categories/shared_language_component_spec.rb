# frozen_string_literal: true

require 'rails_helper'

describe Tables::PostCategoriesController, type: :system do
  describe 'GET /post_categories/:id/edit' do
    it_behaves_like 'shared_language_component' do
      before do
        login_as(user, scope: :user)
        visit edit_post_category_path(post_category, locale: 'ru')
      end

      let(:user) { create(:user, role: :admin) }
      let(:post_category) { create(:post_category) }
      let(:link) { edit_post_category_path(post_category, locale: 'en') }
    end
  end

  describe 'GET /post_categories' do
    it_behaves_like 'shared_language_component' do
      before do
        visit post_categories_path
      end

      let(:link) { post_categories_path(locale: 'en') }
    end
  end
end
