# frozen_string_literal: true

require 'rails_helper'

describe Widgets::SimplesController, type: :request do
  let(:user) { create(:user) }

  context 'with user' do
    before { sign_in(user) }

    it 'responds with :unprocessable_entity and does not redirect to login' do
      post widgets_simples_path, params: { widgets_simple: { title: '1' } }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  context 'without user' do
    it 'responds with :found and redirects to login' do
      post widgets_simples_path, params: { widgets_simple: {} }
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to('http://www.example.com/auth/login')
    end
  end
end
