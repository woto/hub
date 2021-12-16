# frozen_string_literal: true

require 'rails_helper'

describe MentionsController, type: :system, responsible: :admin do
  include_context 'shared mention fill helpers'

  before do
    login_as(Current.responsible, scope: :user)
    visit new_mention_path(locale: :ru)
  end

  image_error_text = 'Image не может быть пустым'
  wrong_extension_error_text = 'Image type must be one of: image/jpeg, image/jpg, image/png, image/gif'

  xcontext 'when image is not filled' do
    it 'shows image error text' do
      click_on('Сохранить')
      expect(page).to have_text(image_error_text)
    end
  end

  context 'when uploaded wrong file' do
    it 'shows wrong extension error text' do
      fill_image(file_name: 'market_categories.xls')
      click_on('Сохранить')
      expect(page).to have_text(wrong_extension_error_text)
    end
  end

  context 'when image is filled' do
    let!(:entity) { create(:entity) }

    it 'does not show image error text' do
      fill_image(file_name: 'jessa_rhodes.jpg')
      click_on('Сохранить')
      expect(page).not_to have_text(image_error_text)
    end

    it 'saves mention with uploaded image' do
      fill_url(url: 'https://example.com', with_image: false)
      fill_topics(topics: ['new'])
      assign_entity(entity: entity)
      fill_sentiments(sentiments: ['positive'])
      fill_kinds(kinds: ['text'])

      fill_image(file_name: 'jessa_rhodes.jpg')

      expect do
        expect do
          expect do
            click_on('Сохранить')
            expect(page).to have_text('Упоминание было успешно создано')
          end.to change(Topic, :count).by(1)
        end.to change(MentionsTopic, :count).by(1)
      end.to change(Mention, :count).by(1)

      expect(Mention.last.image_data).to include('metadata' => include('filename' => 'jessa_rhodes.jpg'))
    end
  end
end
