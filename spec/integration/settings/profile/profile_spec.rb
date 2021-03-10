# frozen_string_literal: true

require 'rails_helper'

describe Settings::ProfilesController, type: :system do
  let(:name) { Faker::Name.name }
  let(:bio) { Faker::Lorem.paragraph }
  let(:phone) { Faker::PhoneNumber.cell_phone_with_country_code }

  before do
    login_as(user, scope: :user)
    visit 'ru/settings/profile'
  end

  context 'when user does not have a profile' do
    let(:user) { create(:user) }

    it 'creates new profile' do
      fill_in 'profile_form[name]', with: name
      fill_in 'profile_form[bio]', with: bio
      select 'American Samoa', from: 'profile_form_time_zone'
      within find('#profile_form_messengers_attributes_0_messenger') do
        find('button').click
        find('a', text: 'WhatsApp').click
        fill_in 'profile_form[messengers_attributes][0][value]', with: phone
      end
      within find('.profile_form_languages') do
        find('.selectize-input').click
        find('div.option', text: 'English General').click
        find('div.option', text: 'Русский').click
      end
      find('footer').click
      click_button('Обновить')

      expect(page).to have_text('Профиль успешно сохранен')
      expect(user.reload.profile.attributes).to include(
        'name' => name,
        'bio' => bio,
        'time_zone' => 'American Samoa',
        'messengers' => [{ 'type' => 'WhatsApp', 'value' => phone }],
        'languages' => ['', 'en', 'ru']
      )
    end
  end

  context 'when user has profile' do
    let(:user) do
      create(:user, profile: create(
        :profile,
        languages: ['en-US'],
        name: 'Тестов Тест Тестович',
        bio: 'Немного о себе',
        time_zone: 'Kathmandu',
        messengers: [{ type: 'WhatsApp', value: '+7 (919) 988-37-22' }]
      ))
    end

    it 'shows filled form' do
      expect(page).to have_field('profile_form[name]', with: 'Тестов Тест Тестович')
      expect(page).to have_field('profile_form[bio]', with: 'Немного о себе')
      expect(page).to have_field('profile_form[time_zone]', with: 'Kathmandu')
      within find('#profile_form_messengers_attributes_0_messenger') do
        expect(page).to have_button(text: 'WhatsApp')
        expect(page).to have_field 'profile_form[messengers_attributes][0][type]', type: :hidden, with: 'WhatsApp'
        expect(page).to have_field('profile_form[messengers_attributes][0][value]', with: '+7 (919) 988-37-22')
      end
      expect(page).to have_select('profile_form[languages][]', visible: :hidden, selected: ['English US'])
    end
  end

  context 'when form has errors' do
    let(:user) { create(:user) }

    it 'shows form errors' do
      click_button('Обновить')
      expect(page).to have_text('Полное имя (ФИО) не может быть пустым')
      expect(page).to have_text('О себе не может быть пустым')
      expect(page).to have_text('Часовой пояс имеет непредусмотренное значение')
      expect(page).to have_text('Тип мессенджера должен быть выбран')
      expect(page).to have_text('Адрес мессенджера не может быть пустым')
      expect(page).to have_text('Язык должен быть выбран')
    end
  end

  context 'when user visits profile page again (with turbo)' do
    let(:user) { create(:user) }

    before do
      within '.list-group' do
        click_on 'Профиль'
      end
    end

    it 'reinitializes selectize and allows to select items' do
      within find('.profile_form_languages') do
        find('.selectize-input').click
        find('div.option', text: 'Русский').click
      end
    end
  end

  context 'when user clicks browser back button' do
    let(:user) { create(:user) }

    it 'shows initial state' do
      # showing form
      within find('.profile_form_languages') do
        expect(page).to have_css('.selectize-control', count: 1)
      end

      # clicking anywhere
      click_on('Новости')
      expect(page).to have_current_path(Regexp.new('/ru/news'))
      # teardown does not have time to execute
      # and we can't test it otherwise
      sleep(1)

      # clicking back
      page.go_back
      within find('.profile_form_languages') do
        expect(page).to have_css('.selectize-control', count: 1)
      end
    end
  end
end
