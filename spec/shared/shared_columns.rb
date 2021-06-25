# frozen_string_literal: true

require 'rails_helper'

shared_examples_for 'shared columns invisible by default', responsible: :admin do
  before do
    object
    login_as(user, scope: :user)
    visit path
    click_on('Колонки')
  end

  it 'does not show column on page load' do
    expect(page).to have_no_text(column_title)
    expect(page).to have_no_text(column_value)

    within find('#new_columns_form') do
      within('.selectize-input') do
        find('input').click
      end
      find('div.option', text: select_title).click
    end

    # loose selectize focus
    find('.card-status-start').click

    click_on 'Обновить'

    expect(page).to have_text(column_title)
    expect(page).to have_text(column_value)
  end
end
