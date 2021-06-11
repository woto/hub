# frozen_string_literal: true

require 'rails_helper'

describe PostsController, type: :system, responsible: :admin do
  let(:post) { create(:post, user: Current.responsible, body: 'body') }
  let(:another_user) { create(:user) }

  it 'fills `Пользователь` correctly' do
    login_as(Current.responsible, scope: :user)
    visit edit_post_path(post, locale: :ru)

    expect(page).to have_select('post[user_id]', visible: :hidden, selected: post.user.to_label)

    within '.post_user' do
      find('.selectize-input').click
      find('input').native.send_key(:backspace)
      find('input').native.send_key(another_user.email[..3])
      find('div.option', text: another_user.email).click
    end

    expect(page).to have_select('post[user_id]', visible: :hidden, selected: another_user.to_label)
  end
end
