# frozen_string_literal: true

require 'rails_helper'

describe WidgetsController, type: :system do
  context 'with user' do
    let(:user) { create(:user) }
    let!(:widget1) { create(:simple_widget, user: user) }
    let!(:widget2) { create(:simple_widget) }

    it 'displays only user widgets list' do
      login_as(user, scope: :user)
      visit new_post_path(locale: :ru)

      within '.post_body' do
        click_on('Вставить виджет')
      end

      expect(page).to have_css("#widget-preview-#{widget1.id}")
      expect(page).to have_no_css("#widget-preview-#{widget2.id}")
    end
  end

  context 'when user does not have any widgets' do
    let(:user) { create(:user) }

    it 'shows welcome text' do
      login_as(user, scope: :user)
      visit new_post_path(locale: :ru)

      within '.post_body' do
        click_on('Вставить виджет')
      end

      expect(page).to have_text('Пока что в вашей коллекции нет ни одного виджета с офферами. Создайте новый!')
    end
  end

  context 'when widgets modal is open', responsible: :admin do
    let!(:widget) { create(:simple_widget, user: Current.responsible) }

    before do
      login_as(Current.responsible, scope: :user)
      visit new_post_path(locale: :ru)
      within '.post_intro' do
        click_on('Вставить виджет')
      end
    end

    context 'when clicking on widget preview' do
      it 'shows widget controls' do
        find("#widget-cover-#{widget.id}").click
        expect(page).to have_link('Вставить виджет в статью')
        expect(page).to have_link('Редактировать виджет')
        expect(page).to have_css '[data-action="posts-widgets#destroyWidget"]'
      end
    end

    context 'when clicks on `Вставить виджет в статью`' do
      it 'inserts widget into appropriate trix editor' do
        find("#widget-cover-#{widget.id}").click
        click_on('Вставить виджет в статью')

        expect(page).to have_field('post[intro]', with: Regexp.new(widget.widgetable.title), type: :hidden)
      end
    end

    context 'when clicks on `Редактировать виджет`' do
      it 'leads to the edit widget page' do
        find("#widget-cover-#{widget.id}").click
        click_on('Редактировать виджет')

        expect(page).to have_text('Редактирование виджета')
      end
    end
  end
end
