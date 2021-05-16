# frozen_string_literal: true

require 'rails_helper'

describe Tables::FavoritesController, type: :system do
  describe 'shared_table' do
    it_behaves_like 'shared_table' do
      let(:objects) do
        create_list(singular, 11, user: user)
      end
      let(:plural) { 'favorites' }
      let(:singular) { 'favorite' }
      let!(:user) { create(:user) }

      before do
        login_as(user, scope: :user)
      end
    end
  end
end
