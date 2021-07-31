# frozen_string_literal: true

require 'rails_helper'

describe 'Favorites shared search everywhere', type: :system do
  describe 'GET /favorites' do
    it_behaves_like 'shared_search_everywhere' do
      before do
        user = create(:user, role: :admin)
        create(:favorite)
        login_as(user, scope: :user)
        visit '/ru/favorites'
      end

      let(:params) do
        { controller: 'tables/favorites', q: q, columns: %w[id name kind is_default favorites_items_count],
          locale: 'ru', per: 20, sort: :id, order: :desc, only_path: true }
      end
    end
  end
end
