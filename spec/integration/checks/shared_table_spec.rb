# frozen_string_literal: true

require 'rails_helper'

describe Tables::ChecksController, type: :system do
  describe 'shared_table' do
    it_behaves_like 'shared_table' do
      let(:objects) do
        admin = create(:user, role: :admin)
        allow_any_instance_of(Check).to receive(:check_amount)

        Current.set(responsible: admin) do
          create_list(singular, 11, user: user, amount: 1, currency: :rub)
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
end
