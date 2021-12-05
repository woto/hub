# frozen_string_literal: true

require 'rails_helper'

describe MentionsController, type: :system, responsible: :admin do
  before do
    login_as(Current.responsible, scope: :user)
    visit new_mention_path(locale: :ru)
  end

  context 'when clicks on "Добавить объект"' do
    it 'opens modal "assign" window' do
      expect(page).not_to have_css('.modal')
      click_on('Добавить объект')
      expect(page).to have_css('.modal')
      expect(page).to have_text('Поиск объекта упоминания')
      expect(page).not_to have_text('Создать новый')
      fill_in('Поиск объекта', with: 'New entity')
      click_on('Создать новый')
      expect(page).to have_text('Создание нового объекта упоминания')
    end
  end
end