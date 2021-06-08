# frozen_string_literal: true

require 'rails_helper'

describe PostsController, type: :system, responsible: :user do
  let(:post) { create(:post, user: Current.responsible) }

  context 'with user' do
    it 'shows edit page' do
      login_as(Current.responsible, scope: :user)
      visit edit_post_path(post, locale: :ru)
      expect(page).to have_text('Редактирование статьи')
    end
  end

  context 'with another user' do
    it 'returns friendly error' do
      login_as(create(:user), scope: :user)
      visit post_path(post, locale: :ru)

      expect(page).to have_text("The page you were looking for doesn't exist")
    end
  end
end
