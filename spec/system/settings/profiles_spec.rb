# frozen_string_literal: true

require 'rails_helper'

describe Settings::ProfilesController do
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
      select "American Samoa", :from => "profile_form_time_zone"
      within find('#profile_form_messengers_attributes_0_messenger') do
        find('button').click
        find('a', text: 'WhatsApp').click
        fill_in 'profile_form[messengers_attributes][0][value]', with: phone
      end
      within find('.profile_form_languages') do
        find('.selectize-input').click
        find('div.option', text: 'English').click
        find('div.option', text: 'Русский').click
      end
      find('footer').click
      click_button('Обновить')

      expect(page).to have_text('Профиль успешно сохранен')
      expect(user.reload.profile.attributes).to include(
        'name' => name,
        'bio' => bio,
        'messengers' => [{ 'type' => 'WhatsApp', 'value' => phone }],
        'languages' => ['', 'en', 'ru']
      )
    end
  end

  context 'when user has profile' do
    let(:user) { create(:user, :with_profile) }

    it 'shows filled form' do
      expect(page).to have_field('profile_form[name]', with: user.profile.name)
      expect(page).to have_field('profile_form[bio]', with: user.profile.bio)
      within find('#profile_form_messengers_attributes_0_messenger') do
        type = user.profile.messengers[0]['type']
        expect(page).to have_button(text: type)
        expect(page).to have_field 'profile_form[messengers_attributes][0][type]', type: :hidden, with: type
        expect(page).to have_field('profile_form[messengers_attributes][0][value]', with: user.profile.messengers[0]['value'])
      end
      within find('#profile_form_messengers_attributes_1_messenger') do
        type = user.profile.messengers[1]['type']
        expect(page).to have_button(text: type)
        expect(page).to have_field 'profile_form[messengers_attributes][1][type]', type: :hidden, with: type
        expect(page).to have_field('profile_form[messengers_attributes][1][value]', with: user.profile.messengers[1]['value'])
      end
      in_their_own_language = Rails.application.config.global[:languages].select do |lng|
        user.profile.languages.include?(lng[:english_name])
      end.map do |lng|
        lng[:language]
      end
      expect(page).to have_select('profile_form[languages][]', visible: false, selected: in_their_own_language)
    end
  end

  context 'when form has errors' do
    let(:user) { create(:user) }

    it 'shows form errors' do
      click_button('Обновить')
      expect(page).to have_text("Полное имя (ФИО) не может быть пустым")
      expect(page).to have_text("О себе не может быть пустым")
      expect(page).to have_text("Часовой пояс имеет непредусмотренное значение")
      expect(page).to have_text("Тип мессенджера должен быть выбран")
      expect(page).to have_text("Адрес мессенджера не может быть пустым")
      expect(page).to have_text("Язык должен быть выбран")
    end
  end
end
