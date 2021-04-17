# frozen_string_literal: true

require 'rails_helper'

describe Tables::PostsController, type: :system do
  describe 'shared_language_component' do
    it_behaves_like 'shared_language_component' do
      before do
        login_as(user, scope: :user)
        visit posts_path
      end

      let(:user) { create(:user) }
      let(:link) { posts_path(locale: 'en') }
    end
  end

  describe 'shared_search_everywhere' do
    it_behaves_like 'shared_search_everywhere' do
      before do
        user = create(:user)
        Current.set(responsible: user) do
          create(:post, user: user)
        end
        login_as(user, scope: :user)
        visit '/ru/posts'
      end

      let(:params) do
        { controller: 'tables/posts', q: q, cols: '0.6.5.16.13', locale: 'ru',
          per: 20, sort: :id, order: :desc, only_path: true }
      end
    end
  end

  describe '#index' do
    describe 'TODO' do
      describe 'shared_table' do
        it_behaves_like 'shared_table' do
          let(:objects) do
            Current.set(responsible: user) do
              create_list(singular, 11, user: user)
            end
          end
          let(:plural) { 'posts' }
          let(:singular) { 'post' }
          let!(:user) { create(:user) }

          before do
            login_as(user, scope: :user)
          end
        end
      end

      describe 'shared_workspace_authenticated' do
        it_behaves_like 'shared_workspace_authenticated' do
          let(:plural) { 'posts' }
          let!(:user) { create(:user, role: 'admin') }
          let(:cols) { '0.6.5.16.13' }
        end
      end
    end
  end
end
