# frozen_string_literal: true

require 'rails_helper'

describe Users::SessionsController do
  let(:user) { build(:user) }

  it 'signs up successfully', browser: :desktop do
    visit '/auth/register/new'
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    fill_in 'user_password_confirmation', with: user.password
    click_button 'register'
    expect(page).to have_text('Welcome! You have signed up successfully.')
    expect(page).to have_current_path('/en-US/dashboard')
    expect_dashboard
    expect_authenticated
  end
end
