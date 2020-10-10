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

  it_behaves_like 'shared_table' do
    let(:objects) { create_list(singular, 10) }
    let(:plural) { 'users' }
    let(:singular) { 'user' }
    let!(:user) { create(:user, role: 'admin') }

    before do
      objects
      User.__elasticsearch__.refresh_index!
      login_as(user, scope: :user)
    end
  end

  it_behaves_like 'shared_workspace' do
    let(:plural) { 'users' }
    let!(:user) { create(:user, role: 'admin') }
    before do
      User.__elasticsearch__.refresh_index!
    end
  end
end
