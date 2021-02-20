# frozen_string_literal: true

require 'rails_helper'

describe 'Feeds page' do
  context 'when feed is present' do
    it "shows row" do
      feed = create(:feed)
      visit "/feeds"
      expect(page).to have_css("#table_feed_#{feed.id}")
    end
  end

  context "when feeds are absent" do
    it 'shows blank page' do
      visit "/feeds"
      expect(page).to have_text('No results found')
    end
  end

  it_behaves_like 'shared_table' do
    let!(:objects) { create_list(singular, 11) }
    let(:plural) { 'feeds' }
    let(:singular) { 'feed' }
    let(:user) { create(:user) }

    before do
      login_as(user, scope: :user)
    end
  end

  context 'when non authorized user attempts to save workspace' do
    it 'proposes to login' do
      create(:feed)
      visit "/ru/feeds?cols=0&dwf=1&per=20"
      within('[data-test-id="workspace-form"]') do
        click_button 'Сохранить'
        expect(page).to have_current_path(new_user_session_path, url: false)
      end
    end
  end

  it_behaves_like 'shared_workspace' do
    let(:cols) { '0.30.3' }
    let(:plural) { 'feeds' }
    let(:user) { create(:user) }
    before do
      create(:feed)
    end
  end
end
