# frozen_string_literal: true

require 'rails_helper'

describe 'Header' do
  context 'when user is not authenticated' do
    it 'shows login link for desktop' do
      visit '/ru/dashboard'
      expect(page).to have_css('.capybara-desktop.capybara-unauthenticated')
      expect(page).to have_no_css('.capybara-mobile.capybara-unauthenticated')
    end

    it 'shows login link for mobile', browser: :mobile do
      visit '/ru/dashboard'
      expect(page).to have_css('.capybara-mobile.capybara-unauthenticated')
      expect(page).to have_no_css('.capybara-desktop.capybara-unauthenticated')
    end
  end

  context 'when user is authenticated' do
    let(:user) { create(:user) }

    before do
      login_as(user, scope: :user)
    end

    it 'shows profile link for desktop' do
      visit '/ru/dashboard'
      expect(page).to have_css('.capybara-desktop.capybara-authenticated')
      expect(page).to have_no_css('.capybara-mobile.capybara-authenticated')
    end

    it 'shows profile link for mobile', browser: :mobile do
      visit '/ru/dashboard'
      expect(page).to have_css('.capybara-mobile.capybara-authenticated')
      expect(page).to have_no_css('.capybara-desktop.capybara-authenticated')
    end
  end
end
