# frozen_string_literal: true

require 'rails_helper'

describe WidgetsController, type: :system do
  context 'when user clicks on `Создать новый виджет`' do
    let(:user) { create(:user) }

    it 'shows new widget types list' do
      login_as(user, scope: :user)
      visit new_post_path(locale: :ru)

      within '.post_body' do
        click_on('Вставить виджет')
      end

      click_on('Создать новый виджет')

      expect(page).to have_text('Выбор типа создаваемого виджета')
    end
  end

  context 'when clicks on simple widget', focus: true do
    let(:user) { create(:user) }

    it 'shows simple widget form' do
      login_as(user, scope: :user)
      visit new_post_path(locale: :ru)

      within '.post_body' do
        click_on('Вставить виджет')
      end

      click_on('Создать новый виджет')
      click_link(href: '/ru/widgets/simples/new')
      expect(page).to have_text('Создание виджета')
    end
  end
end
