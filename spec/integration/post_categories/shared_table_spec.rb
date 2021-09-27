# frozen_string_literal: true

require 'rails_helper'

describe Tables::PostCategoriesController, type: :system do
  describe 'shared_table' do
    it_behaves_like 'shared_table' do
      let(:objects) do
        create_list(singular, 11)
      end
      let(:plural) { 'post_categories' }
      let(:singular) { 'post_category' }
      let!(:user) { create(:user, role: :admin) }

      before do
        login_as(user, scope: :user)
      end
    end
  end
end
