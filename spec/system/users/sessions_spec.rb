# frozen_string_literal: true

require 'rails_helper'

describe Users::SessionsController do
  let(:user) { create(:user) }

  it 'signs in successfully' do
    visit '/ru/auth/login'
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    click_button 'login'
    expect_dashboard
    expect_authenticated
    expect(page).to have_text('Вход в систему выполнен.')
  end

  it 'displays invalid email or password' do
    visit '/ru/auth/login'
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: Faker::Alphanumeric.alphanumeric
    click_button 'login'
    expect(page).to have_text('Неправильный Email или пароль.')
  end

  it 'signes out successfully' do
    login_as(user, scope: :user)
    visit '/ru/dashboard'
    find('.capybara-desktop.capybara-authenticated').click
    click_link 'logout'
    expect(page).to have_text('Выход из системы выполнен.')
  end

  it 'displays you are already signed in' do
    login_as(user, scope: :user)
    visit '/ru/auth/login'
    expect(page).to have_text('Вы уже вошли в систему.')
  end

  it 'tests warden #login_as helper' do
    login_as(user, scope: :user)
    visit '/dashboard'
    expect_authenticated
  end
end
