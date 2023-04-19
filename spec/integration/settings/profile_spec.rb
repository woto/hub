# frozen_string_literal: true

require 'rails_helper'

describe SettingsController, type: :system do
  before do
    login_as(user, scope: :user)
    visit '/settings/profile'
  end

  context 'when messenger added but not filled' do
    let(:user) { create(:user) }

    it 'shows error' do
      click_on 'Добавить...'
      click_button('Save')
      expect(page).to have_text('type is a required field, value is a required field')
    end
  end

  context 'when user does not have a profile' do
    let(:user) { create(:user) }

    it 'creates new profile on submit' do
      page.attach_file('avatar', file_fixture('jessa_rhodes.jpg'))
      fill_in 'name', with: 'Pegasus'
      fill_in 'bio', with: 'Is a winged divine stallion'
      check 'English'
      select 'American Samoa', from: 'time_zone'
      click_on 'Добавить...'
      select 'Telegram', from: 'messengers.0.type'
      fill_in 'messengers.0.value', with: '+7 (789) 454-24-42'

      expect do
        click_button('Save')
        expect(page).to have_text('Профиль успешно изменён')
      end.to change(Profile, :count)
      expect(user.reload.profile.attributes).to include(
        'name' => 'Pegasus', 'bio' => 'Is a winged divine stallion', 'time_zone' => 'American Samoa',
        'messengers' => [{ 'type' => 'Telegram', 'value' => '+7 (789) 454-24-42' }], 'languages' => ['en']
      )
      expect(user.reload.avatar).to eq(Image.last)
    end
  end

  context 'when user has a profile' do
    let(:user) do
      create(:user, :with_avatar, profile: create(
        :profile,
        languages: ['en'], name: 'Marcus Aurelius', bio: 'Roman emperor from 161 to 180 AD and a Stoic philosopher',
        time_zone: 'Kathmandu', messengers: [{ type: 'WhatsApp', value: '+7 (919) 988-37-22' }]
      ))
    end

    it 'viewing profile page shows filled form' do
      expect(page).to have_field('name', with: 'Marcus Aurelius')
      expect(page).to have_field('bio', with: 'Roman emperor from 161 to 180 AD and a Stoic philosopher')
      expect(page).to have_checked_field('English')
      expect(page).to have_field('time_zone', with: 'Kathmandu')
      expect(page).to have_select('messengers.0.type', selected: 'WhatsApp')
      expect(page).to have_field('messengers.0.value', with: '+7 (919) 988-37-22')
      src = GlobalHelper.image_hash([User.last.avatar_relation].compact, %w[100]).first['images']['100']
      expect(page).to have_css("img[src='#{src}']")
    end

    it 'updates profile on submit' do
      expect do
        click_button('Save')
        expect(page).to have_text('Профиль успешно изменён')
      end.not_to change(Profile, :count)
    end
  end
end
