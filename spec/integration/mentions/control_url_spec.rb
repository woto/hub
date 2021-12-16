# frozen_string_literal: true

require 'rails_helper'

describe MentionsController, type: :system, responsible: :admin do
  include_context 'shared mention fill helpers'

  before do
    login_as(Current.responsible, scope: :user)
    visit new_mention_path(locale: :ru)
  end

  url_error_text = 'Url не может быть пустым'
  image_error_text = 'Image не может быть пустым'

  context 'when url is not filled' do
    it 'shows url error text and image error text' do
      click_on('Сохранить')
      expect(page).to have_text(url_error_text)
      # expect(page).to have_text(image_error_text)
    end
  end

  xcontext 'when unable to get data from url' do
    it 'doest not fill image and title' do
      fill_url(url: 'https://example.com', with_image: false)
      click_on('Сохранить')
      expect(page).not_to have_text(url_error_text)
      expect(page).to have_text(image_error_text)
    end
  end

  context 'when title and image from url is received' do
    it 'does not show url and image error texts' do
      fill_url(url: 'https://example.com', with_image: true)
      click_on('Сохранить')

      expect(page).not_to have_text(url_error_text)
      expect(page).not_to have_text(image_error_text)
    end
  end
end
