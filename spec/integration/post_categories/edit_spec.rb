# frozen_string_literal: true

require 'rails_helper'

describe PostCategoriesController, type: :system do
  let(:realm) { create(:realm) }
  let(:parent_category) { create(:post_category, realm: realm) }
  let!(:post_category) { create(:post_category, parent: parent_category, realm: realm) }

  describe 'fills form inputs', responsible: :admin do
    before do
      login_as(Current.responsible, scope: :user)
      visit edit_post_category_path(post_category, locale: :ru)
    end

    it 'fills `Сайт` correctly' do
      expect(page).to have_select('post_category[realm_id]', visible: :hidden, selected: post_category.realm.to_label)
    end

    it 'fills `Название категории` correctly' do
      expect(page).to have_field('post_category[title]', with: post_category.title)
    end

    it 'fills `Родительская категория` correctly' do
      expect(page).to have_select('post_category[parent_id]', visible: :hidden, selected: parent_category.to_label)
    end
  end
end
