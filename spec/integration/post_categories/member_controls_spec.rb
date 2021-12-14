# frozen_string_literal: true

require 'rails_helper'

describe Tables::PostCategoriesController, type: :system do
  let!(:post_category) { create(:post_category) }
  let(:title) { ("№ #{post_category.id}") }

  describe 'control button visibility' do
    before do
      login_as(Current.responsible, scope: :user)
      visit post_categories_path(locale: 'ru')
    end

    context 'when role is user', responsible: :user do

      it 'does not show controls buttons' do
        expect(page).to have_text(title)
      end
    end

    context 'when role is admin', responsible: :admin do
      it 'shows controls buttons' do
        expect(page).to have_text(title)
      end
    end
  end

  describe "member controls buttons' urls", responsible: :user do
    before do
      login_as(Current.responsible, scope: :user)
      visit post_categories_path(locale: 'ru')
    end

    it 'shows `show` button with correct url' do
      expect(page).to have_no_link('Просмотреть', visible: :all)
    end

    it 'does not show `edit` button' do
      expect(page).to have_no_link('Редактировать', visible: :all)
    end

    it 'does not show `destroy` button' do
      expect(page).to have_no_link('Удалить', visible: :all)
    end
  end

  describe "admin member controls buttons' urls", responsible: :admin do
    before do
      login_as(Current.responsible, scope: :user)
      visit post_categories_path(locale: 'ru')
      click_on(title)
    end

    it 'shows `show` button with correct url' do
      expect(page).to have_link('Просмотреть', href: post_category_path(post_category.id, locale: :ru))
    end

    it 'shows `edit` button with correct url' do
      expect(page).to have_link('Редактировать', href: edit_post_category_path(post_category.id, locale: :ru))
    end

    it 'shows `destroy` button with correct url' do
      expect(page).to have_link('Удалить', href: post_category_path(post_category.id, locale: :ru))
    end
  end
end
