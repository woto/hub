# frozen_string_literal: true

require 'rails_helper'

describe Tables::ChecksController, type: :system do
  describe 'GET /checks' do
    it_behaves_like 'shared_search_everywhere' do
      before do
        allow_any_instance_of(Check).to receive(:check_amount)

        user = create(:user, role: :admin)
        Current.set(responsible: user) do
          create(:check)
        end
        login_as(user, scope: :user)
        visit '/ru/checks'
      end

      let(:params) do
        { controller: 'tables/checks', q: q, cols: '0.3.1.2.4.5', locale: 'ru',
          per: 20, sort: :id, order: :desc, only_path: true }
      end
    end
  end
end
