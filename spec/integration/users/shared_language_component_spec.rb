# frozen_string_literal: true

require 'rails_helper'

describe Tables::UsersController, type: :system do
  describe 'GET /users' do
    it_behaves_like 'shared_language_component' do
      before do
        login_as(user, scope: :user)
        visit users_path
      end

      let!(:user) { create(:user, role: 'admin') }
      let(:link) { users_path(locale: 'en') }
    end
  end
end
