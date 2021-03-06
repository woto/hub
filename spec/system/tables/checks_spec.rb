# frozen_string_literal: true

require 'rails_helper'

describe Tables::ChecksController do
  let!(:plural) { 'checks' }
  let!(:singular) { 'check' }

  describe 'shared_search_everywhere' do
    it_behaves_like 'shared_search_everywhere' do
      before do
        user = create(:user, role: :admin)
        Current.set(responsible: user) do
          create(:check)
        end
        login_as(user, scope: :user)
      end

      let(:params) do
        { controller: plural, q: q, cols: '0.1.2.3.5.6', locale: 'ru',
          per: 20, sort: :id, order: :desc, only_path: true }
      end
    end
  end
end
