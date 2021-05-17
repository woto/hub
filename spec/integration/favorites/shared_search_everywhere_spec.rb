# frozen_string_literal: true

require 'rails_helper'

describe Tables::FavoritesController, type: :system do
  describe 'GET /favorites' do
    it_behaves_like 'shared_search_everywhere' do
      before do
        user = create(:user, role: :admin)
        create(:favorite)
        login_as(user, scope: :user)
        visit '/ru/favorites'
      end

      let(:params) do
        { controller: 'tables/favorites', q: q, cols: '0.1.2.3', locale: 'ru',
          per: 20, sort: :id, order: :desc, only_path: true }
      end
    end
  end
end
