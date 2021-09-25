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
        { controller: 'tables/feeds', q: q, columns: %w[id advertiser_name advertiser_picture name offers_count succeeded_at created_at],
          locale: 'ru', per: 20, sort: :id, order: :desc, only_path: true }
      end
    end
  end
end
