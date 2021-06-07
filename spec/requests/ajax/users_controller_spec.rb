# frozen_string_literal: true

require 'rails_helper'

describe Ajax::UsersController, type: :request do
  let!(:admin) { create(:user, role: :admin, email: 'admin@example.com') }
  let!(:user) { create(:user, email: 'user@example.com') }

  before do
    create(:user, email: '1user1@example.com')
  end

  context 'with admin' do
    it 'returns users' do
      sign_in admin
      get ajax_users_path(q: 'user'), xhr: true

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body).to contain_exactly({ 'id' => user.id, 'email' => user.email })
    end
  end

  context 'with user' do
    it 'returns authorization error' do
      sign_in user
      expect {
        get ajax_users_path(q: Faker::Alphanumeric.alphanumeric), xhr: true
      }.to raise_error(Pundit::NotAuthorizedError)
    end
  end
end
