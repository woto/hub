# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Feeds page' do
  context 'when feed is present' do
    it "shows row", browser: :desktop do
      feed = create(:feed)
      Feed.__elasticsearch__.refresh_index!
      visit "/feeds"
      expect(page).to have_css("#table_feed_#{feed.id}")
    end
  end

  context "when feeds are absent" do
    it 'shows blank page', browser: :desktop do
      visit "/feeds"
      expect(page).to have_text('No results found')
    end
  end

  it_behaves_like 'shared_table' do
    let(:objects) { create_list(singular, 11) }
    let(:plural) { 'feeds' }
    let(:singular) { 'feed' }
    let(:user) { create(:user) }

    before do
      objects
      Feed.__elasticsearch__.refresh_index!
      login_as(user, scope: :user)
    end
  end

  context 'when non authorized user attempts to save workspace' do
    it 'proposes to login', browser: :desktop do
      create(:feed)
      Feed.__elasticsearch__.refresh_index!
      visit "/ru/feeds?cols=0&dwf=1&per=20"
      within('[data-test-id="workspace-form"]') do
        click_button 'Сохранить'
        expect(page).to have_current_path(new_user_session_path, url: false)
      end
    end
  end
end
