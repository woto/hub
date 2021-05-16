# frozen_string_literal: true

require 'rails_helper'

describe Tables::ChecksController, type: :system do
  describe 'GET /checks' do
    it_behaves_like 'shared_language_component' do
      before do
        login_as(user, scope: :user)
        visit checks_path
      end

      let!(:user) { create(:user, role: 'admin') }
      let(:link) { checks_path(locale: 'en') }
    end
  end
end
