# frozen_string_literal: true

require 'rails_helper'

describe Tables::HelpController, type: :system do
  describe 'shared_language_component' do
    it_behaves_like 'shared_language_component' do
      before do
        visit help_index_path
      end

      let(:link) { help_index_path(locale: 'en') }
    end
  end

  describe 'shared_search_everywhere' do
    it_behaves_like 'shared_search_everywhere' do
      before do
        user = create(:user, role: :admin)
        create(:post, realm_kind: :help)
        login_as(user, scope: :user)
        visit help_index_path(locale: 'ru')
      end

      let(:params) do
        { controller: 'tables/help', q: q, locale: 'ru',
          sort: 'priority', order: :desc, only_path: true }
      end
    end
  end
end
