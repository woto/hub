# frozen_string_literal: true

require 'rails_helper'

describe SettingsController, type: :system do
  before do
    login_as(user, scope: :user)
    visit '/settings/email'
  end

  let(:user) { create(:user) }

  it 'prefills user email in the text input' do
    expect(page).to have_field('email', with: user.email)
  end

  context 'when new email address is already taken' do
    before do
      create(:user, email: 'reserved@example.com')
    end

    it 'shows error' do
      fill_in('email', with: 'reserved@example.com')
      click_on('Save')
      expect(page).to have_text('Возникла непредвиденная ошибка')
      # expect(page).to have_css('#user_email ~ .invalid-feedback', text: 'Email уже существует')
      expect(page).to have_text('has already been taken')
    end
  end

  context 'when user changes his email' do
    it 'asks to confirm email' do
      fill_in('email', with: 'foo@bar.com')
      click_on('Save')
      # expect(page).to have_current_path('/ru')
      text = /Пожалуйста, проверьте почтовый ящик и перейдите по ссылке, чтобы закончить процедуру проверки: foo@bar.com/
      expect(page).to have_text(text)
    end

    it 'shows pending change' do
      user.update(email: 'foo@bar.com')
      visit '/settings/email'
      text = /Пожалуйста, проверьте почтовый ящик и перейдите по ссылке, чтобы закончить процедуру проверки: foo@bar.com/
      expect(page).to have_text(text)
    end

    it 'sends email to new and old addresses' do
      expect do
        fill_in('email', with: 'foo@bar.com')
        click_on('Save')
        # expect(page).to have_current_path('/ru')
        expect(page).to have_text('Email успешно изменён')
      end.to change { ActionMailer::Base.deliveries.size }.by(2)
      expect(ActionMailer::Base.deliveries.first.to).to eq([user.email])
      expect(ActionMailer::Base.deliveries.last.to).to eq(['foo@bar.com'])
    end

    it 'calls Devise::Mailer.email_changed and Devise::Mailer.confirmation_instructions' do
      allow(Devise::Mailer).to receive(:send).and_call_original
      expect(Devise::Mailer).to receive(:send).with(:confirmation_instructions, any_args)
      expect(Devise::Mailer).to receive(:send).with(:email_changed, any_args)

      fill_in('email', with: 'foo@bar.com')
      click_on('Save')
      expect(page).to have_text('Пожалуйста, проверьте почтовый ящик')
    end
  end
end
