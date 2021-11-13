# frozen_string_literal: true

require 'rails_helper'

describe Settings::APIKeysController, type: :system do
  before do
    login_as(user, scope: :user)
    visit '/ru/settings/api_key'
  end

  let(:user) { create(:user) }

  it 'shows api_key' do
    expect(page).to have_field('api_key', with: user.api_key, readonly: true)
  end

  context 'when regenerate button clicks' do
    it 'regenerate api_key and shows it to the user' do
      key1 = user.api_key
      expect(page).to have_field('api_key', with: key1, readonly: true)
      click_on('Перегенерировать')
      expect(page).to have_text('API ключ был успешно перегенерирован')
      key2 = user.reload.api_key
      expect(page).to have_field('api_key', with: key2, readonly: true)
      expect(key1).not_to eq(key2)
    end
  end
end
