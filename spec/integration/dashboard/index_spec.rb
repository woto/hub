# frozen_string_literal: true

require 'rails_helper'

describe DashboardController, type: :system do
  context 'renders latest-news frame' do
    before do
      user = create(:user)
      login_as(user, scope: :user)
      visit '/ru/dashboard'
    end

    it 'renders latest-news frame' do
      expect(page).to have_css('turbo-frame#latest-news[src="/ru/frames/news/latest"]')
    end
  end
end
