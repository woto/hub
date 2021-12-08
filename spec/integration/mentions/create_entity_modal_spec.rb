# frozen_string_literal: true

require 'rails_helper'

describe MentionsController, type: :system, responsible: :admin do
  before do
    login_as(Current.responsible, scope: :user)
    visit new_mention_path(locale: :ru)

    click_on('Добавить объект')
    fill_in('Поиск объекта', with: 'New entity')
    click_on('Создать новый')
  end

  context 'when saves with wrong data' do
    it 'shows form error' do
      click_on('Добавить синоним')
      fill_in('Название', with: '')
      page.attach_file(file_fixture('market_categories.xls')) do
        find('label[for="entity_image"]').click
      end
      click_on('Сохранить')

      expect(page).to have_text('Название объекта не может быть пустым')
      expect(page).to have_text('Image type must be one of: image/jpeg, image/jpg, image/png, image/gif')
    end
  end

  context 'when saves with correct data' do
    it 'closes the modal and injects card with new entity in the form' do
      expect do
        click_on('Сохранить')

        expect(page).not_to have_css('.modal')
        entity = Entity.last

        expect(page).to have_css("#card_entity_#{entity.id}")
        expect(page).to have_css("#edit_entity_#{entity.id}")
        expect(page).to have_css("#remove_entity_#{entity.id}")
      end.to change(Entity, :count).by(1)
    end
  end
end
