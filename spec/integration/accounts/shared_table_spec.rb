# frozen_string_literal: true

require 'rails_helper'

describe Tables::AccountsController, type: :system do
  describe 'shared_table' do
    it_behaves_like 'shared_table' do
      let(:objects) do
        admin = create(:user, role: :admin)
        Current.set(responsible: admin) do
          create_list(singular, 11)
        end
      end
      let(:plural) { 'accounts' }
      let(:singular) { 'account' }
      let(:user) { create(:user, role: :admin) }

      before do
        login_as(user, scope: :user)
      end
    end
  end
end
