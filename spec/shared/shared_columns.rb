# frozen_string_literal: true

require 'rails_helper'

shared_examples_for 'shared columns visible only to admin', responsible: :admin, focus: true do
  before do
    object
    login_as(user, scope: :user)
    visit path
    click_on('Колонки')
  end

  context 'when user is admin' do
    let(:user) { create(:user, role: :admin) }

    it 'shows columns' do
      within '#new_columns_form' do
        expect(page).to have_text(select_title)
      end

      within 'table' do
        expect(page).to have_text(column_title)
      end

      within "#tr_#{object.id}_td_#{column_id}" do
        expect(page).to have_text(column_value)
      end
    end
  end

  context 'when user is not admin' do
    let(:user) { create(:user) }

    it 'does not show columns' do
      within '#new_columns_form' do
        expect(page).to have_no_text(select_title)
      end

      within 'table' do
        expect(page).to have_no_text(column_title)
      end

      expect(page).to have_css("#tr_#{object.id}_td_id")
      expect(page).to have_no_css("#tr_#{object.id}_td_#{column_id}")
    end
  end
end

shared_examples_for 'shared columns invisible by default', responsible: :admin, focus: true do
  let(:user) { create(:user) }

  before do
    object
    login_as(user, scope: :user)
    visit path
    click_on('Колонки')
  end

  it 'does not show column on page load' do
    expect(page).to have_no_text(column_title)
    expect(page).to have_no_text(column_value)

    within '#new_columns_form' do
      within('.selectize-input') do
        find('input').click
      end
      find('div.option', text: select_title).click
    end

    # loose selectize focus
    find('.card-status-start').click

    click_on 'Обновить'

    expect(page).to have_text(column_title)
    within "#tr_#{object.id}_td_#{column_id}" do
      expect(page).to have_text(column_value)
    end
  end
end
