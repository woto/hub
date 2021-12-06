# frozen_string_literal: true

require 'rails_helper'

describe EntitiesController, type: :system, responsible: :admin do
  let(:entity) { create(:entity, user: Current.responsible, lookups: create_list(:lookup, 2)) }

  before do
    login_as(Current.responsible, scope: :user)
    visit edit_entity_path(entity, locale: :ru)
  end

  context 'when removes lookup title and submits form' do
    it 'shows lookup error text' do
      first('[data-controller="nested-form-item"] input[type="text"]').fill_in(with: '')
      click_on('Сохранить')

      expect(page).to have_text('Невозможно сохранить. Пожалуйста заполните поля')
      expect(page).to have_text('Название синонима не может быть пустым', count: 1)
    end
  end
end