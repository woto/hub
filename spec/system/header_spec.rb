# frozen_string_literal: true

require 'rails_helper'

describe 'Header' do
  context 'when user is not authenticated' do
    it 'shows login link for desktop' do
      visit '/ru/offers'
      expect(page).to have_css('.unauthenticated_component .capybara-desktop')
      expect(page).to have_no_css('.unauthenticated_component .capybara-mobile')
    end

    it 'shows login link for mobile', browser: :mobile do
      visit '/ru/offers'
      expect(page).to have_css('.unauthenticated_component .capybara-mobile')
      expect(page).to have_no_css('.unauthenticated_component .capybara-desktop')
    end
  end

  context 'when user is authenticated' do
    let(:user) { create(:user) }

    before do
      login_as(user, scope: :user)
    end

    it 'shows profile link for desktop' do
      visit '/ru/offers'
      expect(page).to have_css('.authenticated_component .capybara-desktop')
      expect(page).to have_no_css('.authenticated_component .capybara-mobile')
    end

    it 'shows profile link for mobile', browser: :mobile do
      visit '/ru/offers'
      expect(page).to have_css('.authenticated_component .capybara-mobile')
      expect(page).to have_no_css('.authenticated_component .capybara-desktop')
    end
  end
end
