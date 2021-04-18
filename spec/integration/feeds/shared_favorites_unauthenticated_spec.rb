# frozen_string_literal: true

require 'rails_helper'

describe Tables::FeedsController, type: :system do
  describe 'GET /feeds' do
    it_behaves_like 'shared_favorites_unauthenticated' do
      before do
        feed = create(:feed)
        visit '/ru/feeds'
        click_on("favorite-feeds-#{feed.id}")
      end
    end
  end
end
