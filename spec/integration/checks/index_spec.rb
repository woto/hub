# frozen_string_literal: true

require 'rails_helper'

describe Tables::ChecksController, type: :system do
  describe 'shared_language_component' do
    it_behaves_like 'shared_language_component' do
      before do
        login_as(user, scope: :user)
        visit checks_path
      end

      let!(:user) { create(:user, role: 'admin') }
      let(:link) { checks_path(locale: 'en') }
    end
  end

  describe 'shared_search_everywhere' do
    it_behaves_like 'shared_search_everywhere' do
      before do
        user = create(:user, role: :admin)
        Current.set(responsible: user) do
          create(:check)
        end
        login_as(user, scope: :user)
        visit '/ru/checks'
      end

      let(:params) do
        { controller: 'tables/checks', q: q, cols: '0.1.2.3.5.6', locale: 'ru',
          per: 20, sort: :id, order: :desc, only_path: true }
      end
    end
  end

  describe '#index' do
    describe 'TODO' do
      describe 'shared_table' do
        it_behaves_like 'shared_table' do
          let(:objects) do
            admin = create(:user, role: :admin)
            Current.set(responsible: admin) do
              create_list(singular, 11, user: user)
            end
          end
          let(:plural) { 'checks' }
          let(:singular) { 'check' }
          let(:user) { create(:user) }

          before do
            login_as(user, scope: :user)
          end
        end
      end

      describe 'shared_workspace_authenticated' do
        it_behaves_like 'shared_workspace_authenticated' do
          let(:cols) { '0.30.3' }
          let(:plural) { 'checks' }
          let(:user) { create(:user) }
        end
      end
    end
  end
end
