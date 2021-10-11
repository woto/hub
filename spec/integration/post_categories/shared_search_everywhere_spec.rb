# frozen_string_literal: true

require 'rails_helper'

describe 'Post categories shared search everywhere', type: :system do
  describe 'GET /post_categories/:id/edit' do
    it_behaves_like 'shared_search_everywhere' do
      before do
        user = create(:user, role: :admin)
        post_category = create(:post_category)
        login_as(user, scope: :user)
        visit "/ru/post_categories/#{post_category.id}/edit"
      end

      let(:params) do
        { controller: 'post_categories', q: q, locale: 'ru', only_path: true }
      end
    end
  end

  describe 'GET /post_categories' do
    it_behaves_like 'shared_search_everywhere' do
      before do
        user = create(:user)
        create(:post_category)
        login_as(user, scope: :user)
        visit '/ru/post_categories'
      end

      let(:params) do
        { controller: 'tables/post_categories', q: q, locale: 'ru', only_path: true }
      end
    end
  end
end
