# frozen_string_literal: true

require 'rails_helper'

describe Users::RegistrationsController, type: :system do
  let(:user) { build(:user) }

  def send_form(email, password, password_confirmation)
    visit '/ru/auth/register/new'
    fill_in 'user_email', with: email
    fill_in 'user_password', with: password
    fill_in 'user_password_confirmation', with: user.password
    click_button 'Регистрация'
  end

  context 'when there is already registered user with same email' do
    before do
      create(:user, email: user.email)
    end

    it 'does not register new user and shows alert' do
      expect do
        send_form(user.email, user.password, user.password)
        expect(page).to have_text('Невозможно сохранить. Пожалуйста заполните поля')
        expect(page).to have_css('#user_email ~ .invalid-feedback', text: 'Email уже существует')
      end.not_to change(User, :count)
    end
  end

  context 'when form filled correctly' do
    it 'signs up successfully' do
      send_form(user.email, user.password, user.password)
      expect(page).to have_text('Добро пожаловать! Вы успешно зарегистрировались.')
      expect_dashboard
      expect_authenticated
    end

    it 'sends confirmation instructions' do
      allow(Devise::Mailer).to receive(:send).and_call_original
      expect(Devise::Mailer).to receive(:send).with(:confirmation_instructions, any_args)
      send_form(user.email, user.password, user.password)
    end
  end

  context 'when form is not filled' do
    it 'shows errors' do
      send_form('', '', '')
      expect(page).to have_text('Невозможно сохранить. Пожалуйста заполните поля')
      expect(page).to have_css('#user_email ~ .invalid-feedback', text: 'Email не может быть пустым')
      expect(page).to have_css('#user_password ~ .invalid-feedback', text: 'Пароль не может быть пустым')
      expect(page).to have_css('#user_password_confirmation ~ .invalid-feedback', text: '')
    end
  end

  context 'when form filled incorrectly' do
    it 'shows errors' do
      send_form('email', '1', 'confirmation')
      expect(page).to have_text('Невозможно сохранить. Пожалуйста заполните поля')
      expect(page).to have_css('#user_email ~ .invalid-feedback', text: 'Email имеет неверное значение')
      expect(page).to have_css('#user_password ~ .invalid-feedback', text: 'Пароль недостаточной длины (не может быть меньше 6 символов)')
      expect(page).to have_css('#user_password_confirmation ~ .invalid-feedback', text: 'Подтверждение пароля не совпадает со значением поля Пароль')
    end
  end
end
