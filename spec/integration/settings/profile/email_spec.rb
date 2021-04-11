# frozen_string_literal: true

require 'rails_helper'

describe Settings::EmailsController, type: :system do
  before do
    login_as(user, scope: :user)
    visit '/ru/settings/email'
  end

  let(:user) { create(:user) }

  it 'prefills user email in the text input' do
    expect(page).to have_field('user_email', with: user.email)
  end

  context 'when new email address is already taken' do
    before do
      create(:user, email: 'reserved@example.com')
    end

    it 'shows alert' do
      fill_in('user_email', with: 'reserved@example.com')
      click_on('Обновить')
      expect(page).to have_text('Невозможно сохранить. Пожалуйста заполните поля')
      expect(page).to have_css('#user_email ~ .invalid-feedback', text: 'Email уже существует')
    end
  end

  context 'when user changes his email' do
    it 'asks to confirm email' do
      fill_in('user_email', with: 'foo@bar.com')
      click_on('Обновить')
      expect(page).to have_current_path('/ru')
      text = /Пожалуйста, проверьте почтовый ящик и перейдите по ссылке, чтобы закончить процедуру проверки/
      expect(page).to have_text(text)
    end

    it 'shows pending change' do
      fill_in('user_email', with: 'foo@bar.com')
      click_on('Обновить')
      expect(page).to have_current_path('/ru')
      visit '/ru/settings/email'
      expect(page).to have_text('Ожидается подтверждение адреса E-mail: foo@bar.com')
    end

    it 'sends email to new and old addresses' do
      expect do
        fill_in('user_email', with: 'foo@bar.com')
        click_on('Обновить')
        expect(page).to have_current_path('/ru')
      end.to change { ActionMailer::Base.deliveries.size }.by(2)
      expect(ActionMailer::Base.deliveries.first.to).to eq([user.email])
      expect(ActionMailer::Base.deliveries.last.to).to eq(['foo@bar.com'])
    end

    it 'calls Devise::Mailer.email_changed and Devise::Mailer.confirmation_instructions' do
      allow(Devise::Mailer).to receive(:send).and_call_original
      expect(Devise::Mailer).to receive(:send).with(:confirmation_instructions, any_args)
      expect(Devise::Mailer).to receive(:send).with(:email_changed, any_args)

      fill_in('user_email', with: 'foo@bar.com')
      click_on('Обновить')
      expect(page).to have_text('Пожалуйста, проверьте почтовый ящик')
    end
  end
end
