# frozen_string_literal: true

require 'rails_helper'

describe Settings::ProfilesController, type: :system do
  let(:name) { Faker::Name.name }
  let(:bio) { Faker::Lorem.paragraph }
  let(:location) { Faker::Address.full_address }
  let(:phone) { Faker::PhoneNumber.cell_phone_with_country_code }

  before do
    login_as(user, scope: :user)
    visit '/settings/profile'
  end

  context 'when user does not have a profile' do
    let(:user) { create(:user) }

    it 'creates new profile' do
      fill_in 'profile_form[name]', with: name
      fill_in 'profile_form[bio]', with: bio
      fill_in 'profile_form[location]', with: location
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
      click_button('Update')

      expect(page).to have_text('Profile successfully saved')
      expect(user.reload.profile.attributes).to include(
        'name' => name,
        'bio' => bio,
        'location' => location,
        'messengers' => [{'type' => 'WhatsApp', 'value' => phone}],
        'languages' => ['', 'English', 'Russian']
      )
    end
  end

  context 'when user has profile' do
    let(:user) { create(:user, :with_profile) }

    it 'shows filled form' do
      expect(page).to have_field('profile_form[name]', with: user.profile.name)
      expect(page).to have_field('profile_form[bio]', with: user.profile.bio)
      expect(page).to have_field('profile_form[location]', with: user.profile.location)
      within find('#profile_form_messengers_attributes_0_messenger') do
        type = user.profile.messengers[0]['type']
        expect(page).to have_button(text: type)
        expect(page).to have_field "profile_form[messengers_attributes][0][type]", type: :hidden, with: type
        expect(page).to have_field('profile_form[messengers_attributes][0][value]', with: user.profile.messengers[0]['value'])
      end
      within find('#profile_form_messengers_attributes_1_messenger') do
        type = user.profile.messengers[1]['type']
        expect(page).to have_button(text: type)
        expect(page).to have_field "profile_form[messengers_attributes][1][type]", type: :hidden, with: type
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
      click_button('Update')
      expect(page).to have_text("Name can't be blank")
      expect(page).to have_text("Bio can't be blank")
      expect(page).to have_text("Location can't be blank")
      expect(page).to have_text("Type can't be blank")
      expect(page).to have_text("Value can't be blank")
      expect(page).to have_text("Languages can't be blank")
    end
  end
end
