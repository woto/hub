# frozen_string_literal: true

require 'rails_helper'

describe EntitiesController, type: :system, responsible: :admin do
  before do
    login_as(Current.responsible, scope: :user)
    visit new_entity_path(locale: :ru)
  end

  context 'when submits valid form with lookup and image' do
    it 'successfully saves entity, lookup and image' do
      fill_in('Название', with: 'title')

      click_on('Добавить синоним')
      first('[data-controller="nested-form-item"] input[type="text"]').fill_in(with: 'lookup')

      page.attach_file(file_fixture('jessa_rhodes.jpg')) do
        # NOTE: don't remember how to write it prettier, somehow like click_on('entity_image')
        find('label[for="entity_image"]').click
      end

      expect do
        expect do
          click_on('Сохранить')
          expect(page).to have_text('Объект упоминания был успешно создан')
        end.to change(Entity, :count)
      end.to change(Lookup, :count)

      entity = Entity.last
      expect(entity.image_data).to include('id', 'metadata')
      expect(page).to have_current_path(entity_path(Entity.last, locale: :ru), url: false)
    end
  end
end
