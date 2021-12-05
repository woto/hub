# frozen_string_literal: true

require 'rails_helper'

describe MentionsController, type: :system, responsible: :admin do
  let(:mention) { create(:mention, user: Current.responsible, image_data: image_data, entities: [entity]) }
  let(:entity) { create(:entity, lookups: [lookup]) }
  let(:lookup) { create(:lookup, title: 'Lookup title') }
  let(:image_data) do
    ImageUploader.upload(File.open('spec/fixtures/files/jessa_rhodes.jpg', 'rb'), :store).as_json
  end

  before do
    login_as(Current.responsible, scope: :user)
    visit edit_mention_path(mention, locale: :ru)
  end

  context 'when trying to save with wrong data' do
    it 'shows form errors' do
      click_on("edit_entity_#{entity.id}")
      click_on('Добавить синоним')
      fill_in('Название', with: '')
      page.attach_file(file_fixture('market_categories.xls')) do
        find('label[for="entity_image"]').click
      end
      click_on('Сохранить')
      expect(page).to have_text('Название синонима не может быть пустым')
      expect(page).to have_text('Название объекта не может быть пустым')
      expect(page).to have_text('Image type must be one of: image/jpeg, image/jpg, image/png, image/gif')
    end
  end

  context 'when form saves correctly' do
    it 'closes the modal and injects card with updated entity in the form' do
      click_on("edit_entity_#{entity.id}")

      expect do
        fill_in('entity_title', with: 'New entity title')
        fill_in('entity_lookups_attributes_0_title', with: 'New lookup title')
        click_on('Сохранить')

        expect(page).not_to have_css('.modal')
        expect(page).to have_text('New entity title')
        expect(page).to have_css("#card_entity_#{entity.id}")
        expect(page).to have_css("#edit_entity_#{entity.id}")
        expect(page).to have_css("#remove_entity_#{entity.id}")
      end.to change { lookup.reload.title }.from('Lookup title').to('New lookup title')
    end
  end
end
