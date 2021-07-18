# frozen_string_literal: true

require 'rails_helper'

describe DashboardController, type: :system do
  let!(:realm) { Realm.pick(locale: :ru, kind: :news) }
  let(:user) { create(:user) }

  before do
    login_as(user, scope: :user)
    visit '/ru/dashboard'
  end

  context 'articles-latest turbo-frame' do
    it 'renders articles-latest frame' do
      expect(page).to have_css('turbo-frame#articles-latest[src="/ru/frames/articles/latest"]')
    end
  end

  describe 'link to the news' do
    it 'has correct link to the news' do
      expect(page).to have_link(href: articles_url(host: realm.domain, port: Capybara.current_session.server.port))
    end
  end
end
