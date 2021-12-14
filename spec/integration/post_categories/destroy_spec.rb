# frozen_string_literal: true

require 'rails_helper'

describe PostCategoriesController, responsible: :admin, type: :system do
  let!(:post_category) { create(:post_category, realm: realm) }
  let(:realm) { create(:realm, kind: :post) }
  let(:title) { "№ #{post_category.id}" }

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
        click_on(title)
        accept_confirm { click_on('Удалить') }
        expect(page).to have_text('Невозможно удалить запись, так как существуют зависимости: posts')
      end.not_to change(PostCategory, :count)
    end
  end

  context 'when post_category has post_categories' do
    before do
      create(:post_category, parent: post_category, realm: realm)
    end

    it "can't be destroyed" do
      expect do
        click_on(title)
        accept_confirm { click_on('Удалить') }
        expect(page).to have_text('Удаляемая категория не должна иметь дочерних категорий')
      end.not_to change(PostCategory, :count)
    end
  end

  context 'when post_category does not have children associations' do
    it 'can be destroyed' do
      expect do
        click_on(title)
        accept_confirm { click_on('Удалить') }
        expect(page).to have_text('Категория статей была успешно удалена')
      end.to change(PostCategory, :count).by(-1)
    end
  end
end
