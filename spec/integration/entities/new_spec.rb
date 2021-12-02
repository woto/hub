# frozen_string_literal: true

require 'rails_helper'

describe EntitiesController, type: :system, responsible: :admin do
  before do
    login_as(Current.responsible, scope: :user)
    visit new_entity_path(locale: :ru)
  end

  context 'when submits form without filling any input' do
    it 'shows default errors' do
      click_on('Сохранить')

      expect(page).to have_text('Невозможно сохранить. Пожалуйста заполните поля')
      expect(page).to have_text('Название объекта не может быть пустым')
    end
  end

  context 'when clicked on "Добавить синоним" and submits form' do
    it 'shows lookup required error text' do
      click_on('Добавить синоним')
      click_on('Сохранить')

      expect(page).to have_text('Невозможно сохранить. Пожалуйста заполните поля')
      expect(page).to have_text('Название синонима не может быть пустым', count: 1)
    end
  end

  context 'when clicked on "Добавить синоним" twice and submits form' do
    it 'shows lookups required error texts' do
      click_on('Добавить синоним')
      click_on('Добавить синоним')
      click_on('Сохранить')

      expect(page).to have_text('Невозможно сохранить. Пожалуйста заполните поля')
      expect(page).to have_text('Название синонима не может быть пустым', count: 2)
    end
  end

  context 'when clicked on "Добавить синоним" twice and then removed one' do
    it 'shows lookups required error texts' do
      click_on('Добавить синоним')
      click_on('Добавить синоним')
      click_on('Сохранить')

      expect(page).to have_text('Невозможно сохранить. Пожалуйста заполните поля')
      expect(page).to have_text('Название синонима не может быть пустым', count: 2)

      first('[data-action="nested-form-item#remove"]').click
      click_on('Сохранить')
      expect(page).to have_text('Название синонима не может быть пустым', count: 1)
    end
  end

  context 'when added two lookups and one of them is filled and one is not' do
    it 'shows lookup error only once' do
      click_on('Добавить синоним')
      click_on('Добавить синоним')

      first('[data-controller="nested-form-item"] input[type="text"]').fill_in(with: 'foo')
      click_on('Сохранить')

      expect(page).to have_text('Невозможно сохранить. Пожалуйста заполните поля')
      expect(page).to have_text('Название синонима не может быть пустым', count: 1)
    end
  end

  context 'when removes empty lookup with error' do
    it 'does not show that lookup error' do
      click_on('Добавить синоним')
      click_on('Добавить синоним')

      all('[data-controller="nested-form-item"] input[type="text"]').first.fill_in(with: 'foo')
      click_on('Сохранить')

      expect(page).to have_text('Невозможно сохранить. Пожалуйста заполните поля')
      expect(page).to have_text('Название синонима не может быть пустым', count: 1)

      all('[data-controller="nested-form-item"] button[data-action="nested-form-item#remove"]').last.click
      expect(page).not_to have_text('Название синонима не может быть пустым')
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
