# frozen_string_literal: true

require 'rails_helper'

shared_examples 'shared_workspace_unauthenticated' do
  describe 'save workspace' do
    before do
      find("[data-action='table-workspace-form#toggleForm']").click
    end

    it 'proposes to login' do
      within('#workspace-form') do
        click_button 'Сохранить'
      end
      expect(page).to have_current_path(new_user_session_path, url: false)
      expect(page).to have_text('Вам необходимо войти в систему или зарегистрироваться.')
    end
  end
end
