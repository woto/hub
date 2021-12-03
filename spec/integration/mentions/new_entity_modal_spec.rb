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
    end
  end
end