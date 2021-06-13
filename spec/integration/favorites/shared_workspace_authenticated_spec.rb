# frozen_string_literal: true

require 'rails_helper'

describe Tables::FavoritesController, type: :system do
  describe 'shared_workspace_authenticated' do
    it_behaves_like 'shared_workspace_authenticated' do
      let(:cols) { '0.30.3' }
      let(:plural) { 'favorites' }
      let(:user) { create(:user) }
    end
  end
end