# frozen_string_literal: true

require 'rails_helper'

describe PostCategoriesController, type: :system do
  let(:parent_category) { create(:post_category) }
  let(:post_category) do
    create(:post_category,
           created_at: 3.hours.ago,
           title: 'Some post category',
           parent: parent_category,
           realm: parent_category.realm)
  end

  it 'shows PostCategory model attributes correctly' do
    user = create(:user, role: :admin)
    login_as(user, scope: :user)
    visit post_category_path(post_category, locale: :ru)

    within('main') do
      expect(page).to have_text('Some post category')
      expect(page).to have_text(post_category.realm.to_label)
      expect(page).to have_text(post_category.parent.title)
      expect(page).to have_text('3 часа назад')
      expect(page).to have_text('несколько секунд назад')
      expect(page).to have_text('0')
    end
  end
end
