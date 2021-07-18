# frozen_string_literal: true

require 'rails_helper'

describe DashboardController, type: :system do
  context 'articles-latest turbo-frame' do
    before do
      Realm.pick(locale: :ru, kind: :news)
      user = create(:user)
      login_as(user, scope: :user)
      visit '/ru/dashboard'
    end

    it 'renders articles-latest frame' do
      expect(page).to have_css('turbo-frame#articles-latest[src="/ru/frames/articles/latest"]')
    end
  end
end
