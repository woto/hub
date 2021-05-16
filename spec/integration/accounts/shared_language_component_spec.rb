# frozen_string_literal: true

require 'rails_helper'

describe Tables::AccountsController, type: :system do
  describe 'GET /accounts' do
    it_behaves_like 'shared_language_component' do
      before do
        login_as(user, scope: :user)
        visit accounts_path
      end

      let!(:user) { create(:user, role: 'admin') }
      let(:link) { accounts_path(locale: 'en') }
    end
  end
end
