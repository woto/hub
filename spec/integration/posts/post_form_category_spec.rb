# frozen_string_literal: true

require 'rails_helper'

describe PostsController, type: :system, responsible: :admin do
  let(:post) { create(:post, user: Current.responsible) }
  let(:another_post_category) { create(:post_category, realm: post.realm) }

  it 'changes `post[post_category_id]` correctly' do
    login_as(Current.responsible, scope: :user)
    visit edit_post_path(post, locale: :ru)

    expect(page).to have_select('post[post_category_id]', visible: :hidden, selected: post.post_category.to_label)

    within '.post_post_category' do
      find('input').click
      find('input').native.send_key(:backspace)
      find('input').native.send_key(another_post_category.title[..3])
      find('div.option', text: another_post_category.title).click
    end

    expect(page).to have_select('post[post_category_id]', visible: :hidden, selected: another_post_category.to_label)
  end
end
