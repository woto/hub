# frozen_string_literal: true

require 'rails_helper'

describe PostCategoriesController, responsible: :admin, type: :system do
  it 'shows new post category page' do
    login_as(Current.responsible, scope: :user)
    visit new_post_category_path(locale: :ru)
    expect(page).to have_text('Новая категория статей')
  end
end
