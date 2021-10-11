# frozen_string_literal: true

require 'rails_helper'

describe 'Users shared search everywhere', type: :system do
  describe 'GET /users' do
    it_behaves_like 'shared_search_everywhere' do
      before do
        user = create(:user, role: :admin)
        login_as(user, scope: :user)
        visit '/ru/users'
      end

      let(:params) do
        { controller: 'tables/users', q: q, locale: 'ru', only_path: true }
      end
    end
  end
end
