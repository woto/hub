# frozen_string_literal: true

require 'rails_helper'

describe Widgets::SimplesController, type: :request do
  let(:user) { create(:user) }
  let(:widget) { create(:widget, widgetable: zzzzz, user: user) }

  context 'with user' do
    it 'responds with :found and redirects to edit widget path' do
      sign_in(user)
      put widgets_simple_path(id: widget.widgetable, locale: :ru, params: { widgets_simple: { title: '1' } })
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(edit_widgets_simple_path(widget.widgetable, locale: :ru))
    end
  end

  context 'with another user' do
    let(:another_user) { create(:user) }

    it 'responses with `forbidden`' do
      sign_in(another_user)
      put widgets_simple_path(id: widget.widgetable, locale: :ru)
      expect(response).to have_http_status(:forbidden)
    end
  end

  context 'without user' do
    it 'responds with :found' do
      put widgets_simple_path(id: widget.widgetable, locale: :ru)
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to('http://www.example.com/auth/login')
    end
  end
end
