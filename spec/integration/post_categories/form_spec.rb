# frozen_string_literal: true

require 'rails_helper'

describe PostCategoriesController, type: :system do
  let(:post_category) { create(:post_category) }
  let(:user) { create(:user, role: :admin) }

  describe 'shows form errors correctly' do
    before do
      login_as(user, scope: :user)
      visit new_post_category_path(locale: :ru)

    end

    it 'shows errors' do
      click_on('Сохранить')

      expect(page).to have_text('Realm не может отсутствовать')
      expect(page).to have_text('Title не может быть пустым')
    end
  end
end
