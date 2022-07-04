# frozen_string_literal: true

require 'rails_helper'

describe Users::ConfirmationsController, type: :system do
  def send_form(email)
    visit '/ru/auth/verification/new'
    fill_in 'user_email', with: email
    click_button 'Выслать повторно письмо с активацией'
  end

  context 'when confirmation period is over' do
    let(:user) do
      travel_to 15.days.ago do
        create(:user, :unconfirmed)
      end
    end

    it 'shows alert asking to confirm email' do
      login_as(user, scope: :user)
      visit '/ru/dashboard'
      expect(page).to have_text('Вы должны подтвердить вашу учетную запись.')
    end
  end

  context 'when sends form with confirmed email' do
    let(:user) { create(:user) }

    it 'shows notice that email is already confirmed' do
      send_form(user.email)
      expect(page).to have_text('Невозможно сохранить. Пожалуйста заполните поля')
      text = 'Email уже подтверждён. Пожалуйста, попробуйте войти в систему'
      expect(page).to have_css('#user_email ~ .invalid-feedback', text: text)
    end
  end

  context 'when sends form with not confirmed email' do
    let(:user) { create(:user, :unconfirmed) }

    it 'sends confirmation instructions' do
      allow(Devise::Mailer).to receive(:send).and_call_original
      expect(Devise::Mailer).to receive(:send).with(:confirmation_instructions, any_args)
      send_form(user.email)
    end

    it 'redirects to login' do
      send_form(user.email)
      expect(page).to have_current_path('/ru/auth/login')
    end

    it 'shows notice' do
      send_form(user.email)
      text = 'В течение нескольких минут вы получите письмо с инструкциями по подтверждению адреса эл. почты.'
      expect(page).to have_text(text)
    end
  end

  context 'when email is not found' do
    it 'shows alert' do
      send_form(Faker::Internet.email)
      expect(page).to have_text('Невозможно сохранить. Пожалуйста заполните поля')
      expect(page).to have_css('#user_email ~ .invalid-feedback', text: 'Email не найден')
    end
  end

  context 'when form is not filled' do
    it 'shows alert' do
      send_form('')
      expect(page).to have_text('Невозможно сохранить. Пожалуйста заполните поля')
      expect(page).to have_css('#user_email ~ .invalid-feedback', text: 'Email не может быть пустым')
    end
  end

  context 'when confirmation token is valid' do
    before do
      user.send_confirmation_instructions
    end

    let(:user) do
      travel_to 2.days.ago do
        create(:user, :unconfirmed)
      end
    end

    it 'confirms email' do
      visit user_confirmation_path(confirmation_token: user.confirmation_token, locale: :ru)
      expect(page).to have_text('Ваш адрес эл. почты успешно подтвержден.')
    end
  end

  context 'when confirmation token is outdated' do
    before do
      user.send_confirmation_instructions
    end

    let(:user) do
      travel_to 3.days.ago do
        create(:user, :unconfirmed)
      end
    end

    it 'asks to re-request confirmation token' do
      visit user_confirmation_path(confirmation_token: user.confirmation_token, locale: :ru)
      expect(page).to have_text('Невозможно сохранить. Пожалуйста заполните поля')
      text = 'Email должен быть подтвержден в течение 3 дня, пожалуйста, повторите запрос на подтверждение'
      expect(page).to have_css('#user_email ~ .invalid-feedback', text: text)
    end
  end

  context 'when confirmation token is not valid' do
    it 'shows alert' do
      visit user_confirmation_path(confirmation_token: Faker::Alphanumeric.alphanumeric, locale: :ru)
      expect(page).to have_text('Токен подтверждения имеет неверное значение')
    end
  end
end
