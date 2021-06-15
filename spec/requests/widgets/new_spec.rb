# frozen_string_literal: true

require 'rails_helper'

describe WidgetsController, type: :request do
  let(:user) { create(:user) }

  context 'with user' do
    before { sign_in(user) }

    it 'responds with :ok and uses correct template' do
      get new_widget_path
      expect(response).to have_http_status(:ok)
      expect(response).to render_template('widgets/new')
    end
  end

  context 'without user' do
    it 'responds with :found' do
      get new_widget_path
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to('http://www.example.com/auth/login')
    end
  end
end
