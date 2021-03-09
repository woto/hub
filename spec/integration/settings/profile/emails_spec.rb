# frozen_string_literal: true

require 'rails_helper'

describe Settings::EmailsController, type: :system do
  before do
    login_as(user, scope: :user)
    visit '/ru/settings/email'
  end

  let(:user) { create(:user) }

  it 'prefills user user email in text input' do
    expect(page).to have_field('user_email', with: user.email)
  end

  describe 'when user changes his email' do
    it 'asks to confirm email' do
      fill_in('user_email', with: 'foo@bar.com')
      click_on('Обновить')
      expect(page).to have_current_path('/ru')
      expect(page).to have_css('.alert', text: /необходимо подтвердить новый адрес эл. почты/)
    end

    it 'shows pending change' do
      fill_in('user_email', with: 'foo@bar.com')
      click_on('Обновить')
      visit '/ru/settings/email'
      expect(page).to have_text('Ожидается подтверждение адреса E-mail: foo@bar.com')
    end

    it 'sends email to new address' do
      expect do
        fill_in('user_email', with: 'foo@bar.com')
        click_on('Обновить')
        expect(page).to have_current_path('/ru')
      end.to change { ActionMailer::Base.deliveries.size }.by(2)
    end
  end
end
