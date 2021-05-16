# frozen_string_literal: true

require 'rails_helper'

describe Tables::PostsController, type: :system do
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
end
