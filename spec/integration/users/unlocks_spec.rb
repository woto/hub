# frozen_string_literal: true

require 'rails_helper'

describe Users::UnlocksController, type: :system do
  let(:user) { create(:user) }

  def send_form(email)
    visit '/ru/auth/unblock/new'
    fill_in 'user_email', with: email
    click_button 'Выслать подтверждение заново'
  end

  context 'when account is locked' do
    before do
      I18n.locale = :ru
      user.lock_access!
    end

    it 'shows alert that email with unlock instructions were sent' do
      send_form(user.email)
      message = 'В течение нескольких минут вы получите письмо с инструкциями по разблокировке учетной записи.'
      expect(page).to have_text(message)
    end

    it 'sends email with unlock instructions' do
      allow(Devise::Mailer).to receive(:send).and_call_original
      expect(Devise::Mailer).to receive(:send).with(:unlock_instructions, user, any_args)
      send_form(user.email)
    end
  end

  context 'when account is not locked' do
    it 'shows alert that account is not locked' do
      send_form(user.email)
      expect(page).to have_text('Невозможно сохранить. Пожалуйста заполните поля')
      expect(page).to have_css('#user_email ~ .invalid-feedback', text: 'Email не заблокирован')
    end
  end

  context 'when email is not found' do
    it 'shows alert that email is not found' do
      send_form(Faker::Internet.email)
      expect(page).to have_text('Невозможно сохранить. Пожалуйста заполните поля')
      expect(page).to have_css('#user_email ~ .invalid-feedback', text: 'Email не найден')
    end
  end

  context 'when token is valid' do
    let!(:token) { user.lock_access! }

    it 'unlocks account' do
      expect do
        visit user_unlock_path(unlock_token: token)
      end.to change { user.reload.valid_for_authentication? }.from(false).to(true)
    end

    it 'shows alert that account is unlocked' do
      visit user_unlock_path(unlock_token: token, locale: :ru)
      expect(page).to have_text('Ваша учетная запись разблокирована. Теперь вы можете войти в систему.')
    end
  end

  context 'when token is invalid' do
    it 'shows alert that token is invalid' do
      visit user_unlock_path(unlock_token: Faker::Alphanumeric.alphanumeric, locale: :ru)
      expect(page).to have_text('Токен разблокировки имеет неверное значение')
    end
  end
end
