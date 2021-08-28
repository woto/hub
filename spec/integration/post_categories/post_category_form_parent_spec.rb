# frozen_string_literal: true

require 'rails_helper'

describe PostCategoriesController, type: :system, responsible: :admin do
  let(:realm) { create(:realm) }
  let(:parent_category) { create(:post_category, realm: realm) }
  let(:child_category) { create(:post_category, realm: realm, parent: parent_category) }
  let(:category) { create(:post_category, realm: realm, parent: child_category) }

  it 'changes `post_category[parent_id]` correctly' do
    login_as(Current.responsible, scope: :user)
    visit edit_post_category_path(category, locale: :ru)

    expect(page).to have_select('post_category[parent_id]', visible: :hidden, selected: child_category.to_label)

    within '.post_category_parent_id' do
      find('.selectize-input').click
      find('input').native.send_key(:backspace)
      find('input').native.send_key(parent_category.title[..3])
      find('div.option', text: parent_category.title).click
    end

    expect(page).to have_select('post_category[parent_id]', visible: :hidden, selected: parent_category.to_label)
  end
end
