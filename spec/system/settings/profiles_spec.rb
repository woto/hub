# frozen_string_literal: true

require 'rails_helper'

describe Settings::ProfilesController, type: :system, browser: :desktop do
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
        'languages' => ['', 'English', 'Russian']
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
      languages_as_is = user.profile.languages.map do |eng|
        Rails.application.config.global[:languages].find do |language_structure|
          language_structure[:english_name] == eng
        end[:language]
      end
      expect(page).to have_select('profile_form[languages][]', visible: false, selected: languages_as_is)
    end
  end

  context 'when form has errors' do
    let(:user) { create(:user) }

    it 'shows form errors' do
      click_button('Обновить')
      expect(page).to have_text("Name не может быть пустым")
      expect(page).to have_text("Bio не может быть пустым")
      expect(page).to have_text("Time zone имеет непредусмотренное значение")
      expect(page).to have_text("Type должен быть выбран")
      expect(page).to have_text("Value не может быть пустым")
      expect(page).to have_text("Languages должен быть выбран")
    end
  end
end
