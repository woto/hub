# frozen_string_literal: true

require 'rails_helper'

describe PostsController, type: :system, responsible: :admin do
  let(:post) { create(:post, user: Current.responsible) }
  let(:another_user) { create(:user, email: 'aaaaa@aaaaa.aa') }

  it 'changes `post[user_id]` correctly' do
    login_as(Current.responsible, scope: :user)
    visit edit_post_path(post, locale: :ru)

    expect(page).to have_select('post[user_id]', visible: :hidden, selected: post.user.to_label)

    find('#heading-post-item').click

    within '.post_user' do
      find('.selectize-input').click
      find('input').native.send_key(:backspace)
      find('input').native.send_key(another_user.email[..3])
      find('div.option', text: another_user.email).click
    end

    expect(page).to have_select('post[user_id]', visible: :hidden, selected: another_user.to_label)
  end
end
