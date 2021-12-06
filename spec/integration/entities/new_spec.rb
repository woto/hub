# frozen_string_literal: true

require 'rails_helper'

describe EntitiesController, type: :system, responsible: :admin do
  synonym_placeholder = 'Введите синоним'
  title_placeholder = 'Введите название'

  before do
    login_as(Current.responsible, scope: :user)
    visit new_entity_path(locale: :ru)
  end

  context 'when form loads' do
    it 'shows input fields' do
      expect(page).to have_field(title_placeholder)
      expect(page).to have_field(synonym_placeholder)
    end
  end

  context 'when submits form without filling any input' do
    it 'shows default errors' do
      click_on('Сохранить')

      expect(page).to have_text('Невозможно сохранить. Пожалуйста заполните поля')
      expect(page).to have_text('Название объекта не может быть пустым')
      expect(page).to have_field(title_placeholder)
      expect(page).not_to have_field(synonym_placeholder)
    end
  end

  context 'when clicked on "Добавить синоним" and submits form' do
    it 'shows lookup required error text' do
      click_on('Добавить синоним')
      click_on('Сохранить')

      expect(page).to have_text('Невозможно сохранить. Пожалуйста заполните поля')
      expect(page).to have_field(title_placeholder)
      expect(page).not_to have_field(synonym_placeholder)
    end
  end

  context 'when chosen wrong file and submits form' do
    it 'shows image format error text' do
      page.attach_file(file_fixture('market_categories.xls')) do
        # NOTE: don't remember how to write it prettier, somehow like click_on('entity_image')
        find('label[for="entity_image"]').click
      end
      click_on('Сохранить')

      expect(page).to have_text('Невозможно сохранить. Пожалуйста заполните поля')
      expect(page).to have_text('Image type must be one of: image/jpeg, image/jpg, image/png, image/gif')
    end
  end
end
