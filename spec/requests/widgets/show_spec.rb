# frozen_string_literal: true

require 'rails_helper'

describe WidgetsController, type: :request do
  let(:user) { create(:user) }
  let(:widget) { create(:widget, user: user) }

  context 'with user' do
    context 'with json request' do
      it 'responds with :ok and uses correct template' do
        headers = { 'ACCEPT' => 'application/json' }
        sign_in(user)
        get widget_path(widget), headers: headers
        expect(response).to have_http_status(:ok)
        expect(response).to render_template('widgets/show')
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response.parsed_body).to match('content' => be_a(String), 'sgid' => widget.attachable_sgid)
      end
    end
  end

  context 'with another user' do
    let(:another_user) { create(:user) }

    it 'responses with `forbidden`' do
      sign_in(another_user)
      get widget_path(widget)
      expect(response).to have_http_status(:forbidden)
    end
  end

  context 'without user' do
    it 'responds with :found' do
      get widget_path(widget)
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to('http://www.example.com/auth/login')
    end
  end
end
