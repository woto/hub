# frozen_string_literal: true

require 'rails_helper'

describe PostsController, type: :system do
  let(:user) { create(:user) }

  it 'shows new post page' do
    login_as(user, scope: :user)
    visit new_post_path(locale: :ru)
    expect(page).to have_text('Новая статья')
  end
end
