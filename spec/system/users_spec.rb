# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users page' do

  context 'when user is present' do
    it "shows row", browser: :desktop do
      user = create(:user, role: 'admin')
      User.__elasticsearch__.refresh_index!
      login_as(user, scope: :user)
      visit "/users"
      expect(page).to have_css("#table_user_#{user.id}")
    end
  end
end
