# frozen_string_literal: true

require 'rails_helper'

describe Tables::PostCategoriesController, type: :system do
  let!(:post_category) { create(:post_category) }
  let(:title) { 'Управление' }

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

  describe "member controls buttons' urls", responsible: :admin do
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

  describe 'destroy', responsible: :admin do
    before do
      login_as(Current.responsible, scope: :user)
      visit post_categories_path(locale: 'ru')
    end

    context 'when post_category has posts' do
      before do
        create(:post, post_category: post_category)
      end

      it "can't be destroyed" do
        expect do
          click_on('Управление')
          accept_confirm { click_on('Удалить') }
          expect(page).to have_text('Невозможно удалить запись, так как существуют зависимости: posts')
        end.not_to change(PostCategory, :count)
      end
    end

    context 'when post_category does not have posts' do
      it 'can be destroyed' do
        expect do
          click_on('Управление')
          accept_confirm { click_on('Удалить') }
          expect(page).to have_text('Категория статей была успешно удалена')
        end.to change(PostCategory, :count).by(-1)
      end
    end
  end
end
