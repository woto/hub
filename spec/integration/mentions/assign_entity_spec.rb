# frozen_string_literal: true

require 'rails_helper'

describe MentionsController, type: :system, responsible: :admin do
  def visit_page
    login_as(Current.responsible, scope: :user)
    visit new_mention_path(locale: :ru)
    click_on('Добавить объект')
  end

  context 'when clicks on "Добавить объект"' do
    before { visit_page }

    it 'opens modal "assign" window' do
      expect(page).not_to have_css('.modal')
      expect(page).to have_css('.modal')
      expect(page).to have_text('Поиск объекта упоминания')
    end
  end

  context 'when enters the search text' do
    let!(:entity1) { create(:entity, title: 'First entity', lookups: [create(:lookup, title: 'Lookup title')]) }
    let!(:entity2) { create(:entity, title: 'Second entity') }

    before { visit_page }

    it 'searches across existing entities' do
      fill_in('Поиск объекта', with: 'First')
      expect(page).to have_text('First entity')
      expect(page).to have_text('Lookup title')
    end
  end

  context 'when user selects the entity that have been found' do
    let!(:entity1) { create(:entity, title: 'First entity', lookups: [create(:lookup, title: 'Lookup title')]) }

    before { visit_page }

    it 'closes the modal and injects card in the form' do
      fill_in('Поиск объекта', with: 'First')

      expect(page).to have_css("#card_entity_#{entity1.id}")
      sleep(0.5)
      find('.entity-title', text: 'First entity').click
      expect(page).not_to have_css('.modal')
      expect(page).to have_css("#card_entity_#{entity1.id}")
      expect(page).to have_css("#edit_entity_#{entity1.id}")
      expect(page).to have_css("#remove_entity_#{entity1.id}")
    end
  end
end
