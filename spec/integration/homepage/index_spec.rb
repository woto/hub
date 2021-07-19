# frozen_string_literal: true

require 'rails_helper'

describe HomepageController, type: :system do
  context 'when user authenticated' do
    it 'shows `Выбрать товар`' do
      visit root_path(locale: :ru)
      expect(page).to have_link('Выбрать товар', href: offers_path(locale: :ru))
    end
  end

  context 'when user is not authenticated' do
    it 'shows `Личный кабинет`' do
      login_as(create(:user), scope: :user)
      visit root_path(locale: :ru)
      expect(page).to have_link('Личный кабинет', href: dashboard_path(locale: :ru))
    end
  end
end
