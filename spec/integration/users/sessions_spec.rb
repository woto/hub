# frozen_string_literal: true

require 'rails_helper'

describe Users::SessionsController, type: :system do
  let(:user) { create(:user) }

  def send_form(email, password)
    visit '/ru/auth/login'
    fill_in 'user_email', with: email
    fill_in 'user_password', with: password
    click_button 'Войти'
  end

  context 'when user enters correct login and password' do
    it 'signs in successfully' do
      send_form(user.email, user.password)
      expect_dashboard
      expect_authenticated
      expect(page).to have_text('Вход в систему выполнен.')
    end
  end

  context 'when user enters incorrect login and password' do
    it 'displays invalid email or password message' do
      send_form(user.email, Faker::Alphanumeric.alphanumeric)
      expect(page).to have_text('Неправильный Email или пароль.')
    end

    it 'changes failed login attempts' do
      expect do
        send_form(user.email, Faker::Alphanumeric.alphanumeric)
        expect(page).to have_text('Неправильный Email или пароль.')
      end.to change { user.reload.failed_attempts }.by(1)
    end
  end

  context 'when user clicks on logout' do
    it 'signs out successfully' do
      login_as(user, scope: :user)
      visit '/ru/dashboard'
      find('.authenticated_component .capybara-desktop').click
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

  describe 'access with unconfirmed email' do
    context 'when confirmation time is over' do
      let(:user) do
        travel_to 15.days.ago do
          create(:user, :unconfirmed)
        end
      end

      it 'shows alert asking to confirm email' do
        send_form(user.email, user.password)
        expect(page).to have_text('Вы должны подтвердить вашу учетную запись.')
      end
    end

    context 'when confirmation time is not over' do
      let(:user) do
        travel_to 13.days.ago do
          create(:user, :unconfirmed)
        end
      end

      it 'logs in' do
        send_form(user.email, user.password)
        expect_dashboard
        expect_authenticated
        expect(page).to have_text('Вход в систему выполнен.')
      end
    end
  end

  context 'when user has last attempt to login' do
    before do
      19.times do
        user.increment_failed_attempts
      end
    end

    context 'when user enters correct login and password' do
      it 'logs in' do
        send_form(user.email, user.password)
        expect_dashboard
        expect_authenticated
        expect(page).to have_text('Вход в систему выполнен.')
      end
    end

    context 'when user enters wrong login and password' do
      it 'locks account' do
        expect do
          send_form(user.email, Faker::Lorem.word)
          expect(page).to have_text('Ваша учетная запись заблокирована.')
        end.to change { user.reload.valid_for_authentication? }.from(true).to(false)
      end

      it 'shows alert that account is locked' do
        send_form(user.email, Faker::Lorem.word)
        expect(page).to have_text('Ваша учетная запись заблокирована.')
      end

      it 'sends unlock email' do
        allow(Devise::Mailer).to receive(:send).and_call_original
        expect(Devise::Mailer).to receive(:send).with(:unlock_instructions, user, any_args)
        send_form(user.email, Faker::Alphanumeric.alphanumeric)
      end
    end
  end
end
