# frozen_string_literal: true

require 'rails_helper'

describe Tables::UsersController, type: :system do
  describe 'shared_table' do
    it_behaves_like 'shared_table' do
      let(:objects) { create_list(singular, 10) }
      let(:plural) { 'users' }
      let(:singular) { 'user' }
      let!(:user) { create(:user, role: 'admin') }

      before do
        login_as(user, scope: :user)
      end
    end
  end
end
