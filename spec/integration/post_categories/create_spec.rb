
require 'rails_helper'

describe PostCategoriesController, responsible: :admin, type: :system do

  context 'when form submits' do
    let!(:post_category) { create(:post_category, realm: realm) }
    let!(:realm) { create(:realm, kind: :post) }

    it 'creates post_category' do
      login_as(Current.responsible, scope: :user)
      visit new_post_category_path(locale: :ru)

      within '.post_category_realm' do
        find('.selectize-input').click
        find('input').native.send_key(realm.to_label[..3])
        find('div.option', text: realm.to_label).click
      end

      fill_in('post_category_title', with: 'Some title')

      within '.post_category_parent_id' do
        find('.selectize-input').click
        find('input').native.send_key(post_category.to_label[..3])
        find('div.option', text: post_category.to_label).click
      end

      expect do
        click_button('Сохранить категорию статей')
        expect(page).to have_text('Категори статей была успешно создана')
      end.to change(PostCategory, :count)
    end
  end
end