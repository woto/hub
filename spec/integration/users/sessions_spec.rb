# frozen_string_literal: true

require 'rails_helper'

describe Users::SessionsController do
  let(:user) { create(:user) }

  def login(email, password)
    fill_in 'user_email', with: email
    fill_in 'user_password', with: password
    click_button 'login'
  end

  context 'when user enters correct login and password' do
    it 'signs in successfully' do
      visit '/ru/auth/login'
      login(user.email, user.password)
      expect_dashboard
      expect_authenticated
      expect(page).to have_text('Вход в систему выполнен.')
    end
  end

  context 'when user enters incorrect login and password' do
    it 'displays invalid email or password message' do
      visit '/ru/auth/login'
      login(user.email, Faker::Alphanumeric.alphanumeric)
      expect(page).to have_text('Неправильный Email или пароль.')
    end

    it 'changes failed login attempts' do
      expect do
        visit '/ru/auth/login'
        login(user.email, Faker::Alphanumeric.alphanumeric)
      end.to change { user.reload.failed_attempts }.by(1)
    end
  end

  context 'when user clicks on logout' do
    it 'signs out successfully' do
      login_as(user, scope: :user)
      visit '/ru/dashboard'
      find('.capybara-desktop.capybara-authenticated').click
      click_link 'logout'
      expect(page).to have_text('Выход из системы выполнен.')
    end
  end

  context 'when logged in user visits login page' do
    it 'displays you are already signed in' do
      login_as(user, scope: :user)
      visit '/ru/auth/login'
      expect(page).to have_text('Вы уже вошли в систему.')
    end
  end

  it 'tests warden #login_as helper' do
    login_as(user, scope: :user)
    visit '/dashboard'
    expect_authenticated
  end

  context 'when user has last attempt to login' do
    before do
      19.times do
        user.increment_failed_attempts
      end
    end

    context 'when user enters correct login and password' do
      it 'logins' do
        visit '/ru/auth/login'
        login(user.email, user.password)
        expect_dashboard
        expect_authenticated
        expect(page).to have_text('Вход в систему выполнен.')
      end
    end

    context 'when he enters wrong login and password' do
      it 'locks account' do
        expect do
          visit '/ru/auth/login'
          login(user.email, Faker::Lorem.word)
        end.to change { user.reload.valid_for_authentication? }.from(true).to(false)
      end

      it 'shows alert' do
        visit '/ru/auth/login'
        login(user.email, Faker::Lorem.word)
        expect(page).to have_text('Ваша учетная запись заблокирована.')
      end

      it 'sends unlock email' do
        allow(Devise::Mailer).to receive(:send).and_call_original
        visit '/ru/auth/login'
        login(user.email, Faker::Lorem.word)
        expect(Devise::Mailer).to have_received(:send).with(:unlock_instructions, user, any_args)
      end
    end
  end
end
