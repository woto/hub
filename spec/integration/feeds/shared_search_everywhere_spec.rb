# frozen_string_literal: true

require 'rails_helper'

describe 'Feeds shared search everywhere', type: :system do
  describe 'GET /feeds' do
    it_behaves_like 'shared_search_everywhere' do
      before do
        user = create(:user, role: :admin)
        create(:feed)
        login_as(user, scope: :user)
        visit '/ru/feeds'
      end

      let(:params) do
        { controller: 'tables/feeds', q: q, locale: 'ru', only_path: true }
      end
    end
  end
end
