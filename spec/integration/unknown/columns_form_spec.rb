# frozen_string_literal: true

require 'rails_helper'

describe Tables::FeedsController, type: :system do
  before do
    visit feeds_path({ q: 'a', per: 5, page: 10, sort: 'id', order: 'asc', columns: %w[id name],
                       filters: { id: { max: 10, min: 1 } }, trash: 'trash', locale: 'ru' })
  end

  context 'when page loads' do
    it 'has correct model field value' do
      expect(page).to have_field('columns_form[model]', with: 'feeds', type: :hidden)
    end

    it 'has correct state field value' do
      params = { 'q' => 'a', 'per' => '5', 'page' => '10', 'sort' => 'id', 'order' => 'asc',
                 'filters' => { 'id' => { 'min' => '1', 'max' => '10' } }, 'columns' => %w[id name] }

      field = page.find_field('columns_form[state]', type: :hidden)
      expect(JSON.parse(field.value)).to eq(params)
    end
  end

  context "when sent form's data is not correct" do
    before do
      click_on('Колонки')

      expect(page).to have_select('columns_form[displayed_columns][]',
                                  visible: :hidden, selected: ['Идентификационный номер прайса', 'Название прайса'])

      expect(page).not_to have_text('недостаточной длины')

      within '.columns_form_displayed_columns' do
        find('.selectize-input').click(x: 100, y: 0)
        find('input').native.send_key(:backspace)
        find('input').native.send_key(:backspace)
      end

      # collapse selectize
      find('.page-title').click

      click_on('Сохранить')
      expect(page).to have_text('недостаточной длины')
    end

    it 'preserves correct modal field value' do
      expect(page).to have_field('columns_form[model]', with: 'feeds', type: :hidden)
    end

    it 'preserves correct state field value' do
      params = { 'q' => 'a', 'per' => '5', 'page' => '10', 'sort' => 'id', 'order' => 'asc',
                 'filters' => { 'id' => { 'min' => '1', 'max' => '10' } }, 'columns' => %w[id name] }

      field = page.find_field('columns_form[state]', type: :hidden)
      expect(JSON.parse(field.value)).to eq(params)
    end
  end

  it 'redirects to correct page after save' do
    click_on('Колонки')

    within '#new_columns_form' do
      within('.selectize-input') do
        find('input').click
      end
      find('div.option', text: 'Дата изменения прайса').click
    end

    # collapse selectize
    find('.card-status-start').click

    click_on 'Сохранить'

    expect(page).to(
      have_current_path(
        feeds_path({ q: 'a', per: 5, page: 10, sort: 'id', order: 'asc', columns: %w[id name updated_at],
                     filters: { id: { max: 10, min: 1 } }, locale: 'ru' })
      )
    )
  end
end
