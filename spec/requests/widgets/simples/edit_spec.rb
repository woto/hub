# frozen_string_literal: true

require 'rails_helper'

describe Widgets::SimplesController, type: :request do
  let(:user) { create(:user) }
  let(:widget) { create(:simple_widget, user: user) }

  context 'with user' do
    it 'responds with :ok and uses correct template' do
      sign_in(user)
      get edit_widgets_simple_path(widget.widgetable)
      expect(response).to have_http_status(:ok)
      expect(response).to render_template('widgets/simples/edit')
    end
  end

  context 'with another user' do
    let(:another_user) { create(:user) }

    it 'responses with `forbidden`' do
      sign_in(another_user)
      get edit_widgets_simple_path(widget.widgetable)
      expect(response).to have_http_status(:forbidden)
    end
  end

  context 'without user' do
    it 'responds with :found and redirects to login' do
      get edit_widgets_simple_path(widget.widgetable)
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to('http://www.example.com/auth/login')
    end
  end
end
