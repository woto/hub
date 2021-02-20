# frozen_string_literal: true

require 'rails_helper'

describe 'Users page' do
  context 'when user is present' do
    it "shows row" do
      user = create(:user, role: 'admin')
      login_as(user, scope: :user)
      visit "/users"
      expect(page).to have_css("#table_user_#{user.id}")
    end
  end

  describe 'shared_table' do
    it_behaves_like 'shared_table' do
      let!(:objects) { create_list(singular, 10) }
      let(:plural) { 'users' }
      let(:singular) { 'user' }
      let!(:user) { create(:user, role: 'admin') }

      before do
        login_as(user, scope: :user)
      end
    end
  end

  describe 'shared_workspace' do
    it_behaves_like 'shared_workspace' do
      let(:plural) { 'users' }
      let!(:user) { create(:user, role: 'admin') }
      let(:cols) { '0.6' }
    end
  end
end
