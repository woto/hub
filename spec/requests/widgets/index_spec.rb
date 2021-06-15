# frozen_string_literal: true

require 'rails_helper'

describe WidgetsController, type: :request do
  let(:user) { create(:user) }
  let(:widget) { create(:widget, user: user) }

  context 'with user' do
    before { sign_in(user) }

    context 'with http request' do
      it 'responds with :ok and uses correct template' do
        get widgets_path
        expect(response).to have_http_status(:ok)
        expect(response).to render_template('widgets/index')
        expect(response.content_type).to eq('text/html; charset=utf-8')
      end
    end

    context 'with json request' do
      headers = { 'ACCEPT' => 'application/json' }

      it 'responds with :ok and uses correct template' do
        get widgets_path, headers: headers
        expect(response).to have_http_status(:ok)
        expect(response).to render_template('widgets/index')
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response.parsed_body).to match({ 'content' => be_a(String) })
      end
    end
  end

  context 'without user' do
    it 'responds with :found' do
      get widgets_path
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to('http://www.example.com/auth/login')
    end
  end
end
