# frozen_string_literal: true

require 'rails_helper'

describe Tables::PostCategoriesController, type: :system do
  let(:title) { 'Новая категория статей' }

  describe 'control button visibility' do
    before do
      login_as(Current.responsible, scope: :user)
      visit post_categories_path(locale: 'ru')
    end

    context 'when role is user', responsible: :user do
      it 'does not show controls buttons' do
        expect(page).to have_no_text title
      end
    end

    context 'when role is admin', responsible: :admin do
      it 'shows controls buttons' do
        expect(page).to have_text title
      end
    end
  end

  describe 'control button url', responsible: :admin do
    before do
      login_as(Current.responsible, scope: :user)
      visit post_categories_path(locale: 'ru')
      click_on(title)
    end

    it 'has correct url' do
      expect(page).to have_link(title, href: new_post_category_path(locale: :ru))
    end
  end
end
