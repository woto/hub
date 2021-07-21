# frozen_string_literal: true

require 'rails_helper'

describe Header::NewsComponent, type: :system do
  let(:realm) { create(:realm, locale: 'ru', kind: :news) }

  describe 'index' do
    it 'shows correct link to the news' do
      login_as(create(:user), scope: :user)
      visit dashboard_path(locale: realm.locale)
      expect(page).to have_link('Новости', href: articles_url(host: realm.domain,
                                                              port: Capybara.current_session.server.port))
    end
  end
end
