# frozen_string_literal: true

require 'rails_helper'

describe Tables::PostCategoriesController do
  let!(:plural) { 'post_categories' }
  let!(:singular) { 'post_category' }

  describe 'shared_workspace_unauthenticated' do
    it_behaves_like 'shared_workspace_unauthenticated' do
      before do
        create(:post_category)
      end
    end
  end

  describe 'shared_favorites_unauthenticated' do
    it_behaves_like 'shared_favorites_unauthenticated' do
      before do
        post_category = create(:post_category)
        visit "/ru/#{plural}"
        click_on("favorite-#{post_category.id}")
      end
    end
  end

  describe 'shared_search_everywhere' do
    it_behaves_like 'shared_search_everywhere' do
      before do
        user = create(:user, role: :admin)
        create(:post_category)
        login_as(user, scope: :user)
      end

      let(:params) do
        { controller: plural, q: q, cols: '0.1.3.2', locale: 'ru',
          per: 20, sort: :id, order: :desc, only_path: true }
      end
    end
  end
end
