# frozen_string_literal: true

require 'rails_helper'

describe Tables::FavoritesController, type: :system do
  describe 'GET /favorites' do
    it_behaves_like 'shared_language_component' do
      before do
        login_as(user, scope: :user)
        visit favorites_path
      end

      let!(:user) { create(:user) }
      let(:link) { favorites_path(locale: 'en') }
    end
  end
end
