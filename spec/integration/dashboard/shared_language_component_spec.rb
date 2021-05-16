# frozen_string_literal: true

require 'rails_helper'

describe DashboardController, type: :system do
  describe 'GET /dashboard' do
    it_behaves_like 'shared_language_component' do
      before do
        login_as(user, scope: :user)
        visit '/ru/dashboard'
      end

      let!(:user) { create(:user) }
      let(:link) { dashboard_path(locale: 'en') }
    end
  end
end
