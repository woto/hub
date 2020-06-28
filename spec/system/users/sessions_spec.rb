require 'rails_helper'

describe Users::SessionsController, type: :system do
  let(:user) { create(:user) }

  it 'signs in successfully' do
    visit '/auth/login'
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    click_button 'login'
    expect_dashboard
    expect_authenticated
    expect(page).to have_text('Signed in successfully.')
  end

  it 'displays invalid email or password' do
    visit '/auth/login'
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: Faker::Alphanumeric.alphanumeric
    click_button 'login'
    expect(page).to have_text('Invalid Email or password.')
  end

  it 'signes out successfully' do
    login_as(user, scope: :user)
    visit '/dashboard'
    click_link 'authenticated'
    click_link 'logout'
    expect(page).to have_text('Signed out successfully.')
  end

  it 'displays you are already signed in' do
    login_as(user, scope: :user)
    visit '/auth/login'
    expect(page).to have_text('You are already signed in.')
  end

  it 'tests warden #login_as helper' do
    login_as(user, scope: :user)
    visit '/dashboard'
    expect_authenticated
  end
end
