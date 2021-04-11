# frozen_string_literal: true

require 'rails_helper'

describe Settings::PasswordsController, type: :system do
  before do
    login_as(user, scope: :user)
    visit '/ru/settings/password'
  end

  let(:user) { create(:user) }

  it 'shows form with empty fields' do
    expect(page).to have_field('user_password', with: '')
    expect(page).to have_field('user_password_confirmation', with: '')
  end

  it 'changes password' do
    fill_in('user_password', with: '123456')
    fill_in('user_password_confirmation', with: '123456')
    expect do
      click_on('Обновить')
      expect(page).to have_current_path('/ru')
    end.to(change { user.reload.valid_password?('123456') }.from(false).to(true))
  end

  it 'redirects to root page' do
    fill_in('user_password', with: '123456')
    fill_in('user_password_confirmation', with: '123456')
    click_on('Обновить')
    expect(page).to have_current_path('/ru')
    expect(page).to have_css('.alert', text: /Ваша учетная запись изменена/)
  end

  it 'sends password change email notification' do
    expect do
      fill_in('user_password', with: '123456')
      fill_in('user_password_confirmation', with: '123456')
      click_on('Обновить')
      expect(page).to have_current_path('/ru')
    end.to change { ActionMailer::Base.deliveries.size }.by(1)
    expect(ActionMailer::Base.deliveries.first.to).to eq([user.email])
  end

  context 'when new password is too short' do
    it 'shows error' do
      fill_in('user_password', with: '123')
      fill_in('user_password_confirmation', with: '123')
      expect do
        click_on('Обновить')
        expect(page).to have_css('#user_password ~ .invalid-feedback', text: 'Пароль недостаточной длины')
        expect(page).to have_css('.alert', text: 'Невозможно сохранить')
      end.not_to(change(user, :encrypted_password))
    end
  end

  context 'when password does not match password confirmation' do
    it 'shows error' do
      fill_in('user_password', with: '123456')
      fill_in('user_password_confirmation', with: '654321')
      expect do
        click_on('Обновить')
        expect(page).to have_css('#user_password_confirmation ~ .invalid-feedback',
                                 text: 'Подтверждение пароля не совпадает')
        expect(page).to have_css('.alert', text: 'Невозможно сохранить')
      end.not_to(change(user, :encrypted_password))
    end
  end
end
