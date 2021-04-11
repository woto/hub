# frozen_string_literal: true

require 'rails_helper'

describe Users::PasswordsController, type: :system do
  let(:user) { create(:user) }

  def send_form(email)
    visit '/ru/auth/password/new'
    fill_in 'user_email', with: email
    click_button 'Выслать новый пароль'
  end

  context 'when email is empty' do
    it 'shows errors' do
      send_form('')
      expect(page).to have_text('Невозможно сохранить. Пожалуйста заполните поля')
      expect(page).to have_css('#user_email ~ .invalid-feedback', text: 'Email не может быть пустым')
    end
  end

  context 'when email is not found' do
    it 'shows errors' do
      send_form(Faker::Internet.email)
      expect(page).to have_text('Невозможно сохранить. Пожалуйста заполните поля')
      expect(page).to have_css('#user_email ~ .invalid-feedback', text: 'Email не найден')
    end
  end

  context 'when email is correct' do
    it 'redirects to login form' do
      send_form(user.email)
      expect(page).to have_current_path('/ru/auth/login')
    end

    it 'shows notice' do
      send_form(user.email)
      text = 'В течение нескольких минут вы получите письмо с инструкциями по восстановлению пароля'
      expect(page).to have_text(text)
    end

    it 'sends reset password instructions' do
      allow(Devise::Mailer).to receive(:send).and_call_original
      expect(Devise::Mailer).to receive(:send).with(:reset_password_instructions, any_args)
      send_form(user.email)
    end
  end

  def change_password(password, password_confirmation)
    fill_in 'user_password', with: password
    fill_in 'user_password_confirmation', with: password_confirmation
    click_button 'Изменить мой пароль'
  end

  context 'when token is valid' do
    before do
      token = user.send_reset_password_instructions
      visit edit_user_password_path(reset_password_token: token)
    end

    context 'when form filled correctly but user confirmation period is over' do
      before do
        user.update(confirmation_sent_at: 1.year.ago, confirmed_at: nil)
      end

      # TODO: should it be rewritten to auto confirm email if user anyway received email
      # with reset password token? Awkward logic or I missed something?
      it 'changes password but asks user to confirm email' do
        expect do
          change_password('123123', '123123')
          expect(page).to have_text('Вы должны подтвердить вашу учетную запись.')
        end.to change { user.reload.valid_password?('123123') }.from(false).to(true)
      end
    end

    context 'when form filled correctly but account is locked' do
      before do
        user.lock_access!
      end

      it 'logs in user even if account were locked' do
        expect do
          change_password('123123', '123123')
          expect(page).to have_current_path('/ru')
          expect(page).to have_text('Ваш пароль изменен. Теперь вы вошли в систему.')
        end.to change { user.reload.valid_password?('123123') }.from(false).to(true)
      end
    end

    context 'when form filled correctly' do
      it 'changes password, redirects to root path, shows notice' do
        expect do
          change_password('123123', '123123')
          expect(page).to have_current_path('/ru')
          expect(page).to have_text('Ваш пароль изменен. Теперь вы вошли в систему.')
        end.to change { user.reload.valid_password?('123123') }.from(false).to(true)
      end
    end

    context 'when form does not filled' do
      it 'shows alert and does not change password' do
        expect do
          change_password('', '')
          expect(page).to have_text('Невозможно сохранить. Пожалуйста заполните поля')
          expect(page).to have_css('#user_password ~ .invalid-feedback', text: 'Пароль не может быть пустым')
        end.not_to(change { user.reload.valid_password?('123123') })
      end
    end

    context 'when form filled incorrectly' do
      it 'shows alert and does not change password' do
        expect do
          change_password('1', '2')
          expect(page).to have_text('Невозможно сохранить. Пожалуйста заполните поля')
          text = 'Пароль недостаточной длины (не может быть меньше 6 символов)'
          expect(page).to have_css('#user_password ~ .invalid-feedback', text: text)
          text = 'Подтверждение пароля не совпадает со значением поля Пароль'
          expect(page).to have_css('#user_password_confirmation ~ .invalid-feedback', text: text)
        end.not_to(change { user.reload.valid_password?('123123') })
      end
    end
  end

  context 'when token is invalid' do
    before do
      visit edit_user_password_path(reset_password_token: Faker::Alphanumeric.alphanumeric)
    end

    it 'shows alert, does not change password' do
      expect do
        change_password('123123', '123123')
        expect(page).to have_text('Невозможно сохранить. Пожалуйста заполните поля')
        expect(page).to have_text('Токен сброса пароля имеет неверное значение')
      end.not_to(change { user.reload.valid_password?('123123') })
    end
  end
end
