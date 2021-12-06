# frozen_string_literal: true

require 'rails_helper'

describe EntitiesController, type: :system, responsible: :admin do
  let(:entity) { create(:entity, user: Current.responsible, lookups: create_list(:lookup, 2)) }

  before do
    login_as(Current.responsible, scope: :user)
    visit edit_entity_path(entity, locale: :ru)
  end

  context 'when removes one lookup, adds another and submits form' do
    let(:lookup) { Lookup.first }

    it 'stores changes in database' do
      within("#lookup_#{lookup.id}") do
        find('button[data-action="nested-form-item#remove"]').click
      end

      click_on('Добавить синоним')

      within('#new_lookup') do
        find('input[type="text"]').fill_in(with: 'lookup')
      end

      expect do
        expect do
          click_on('Сохранить')
          expect(page).to have_text('Объект упоминания был успешно изменен')
        end.not_to change(Entity, :count)
      end.not_to change(Lookup, :count)

      expect { lookup.reload }.to raise_error(ActiveRecord::RecordNotFound)
      expect(Lookup.last.title).to eq('lookup')
    end
  end
end
