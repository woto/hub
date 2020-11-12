# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Posts page' do
  context 'when post is present' do
    it "shows row", browser: :desktop do
      user = create(:user)
      post = create(:post, user: user)
      Post.__elasticsearch__.refresh_index!
      login_as(user, scope: :user)
      visit "/posts"
      expect(page).to have_css("#table_post_#{post.id}")
    end
  end

  context "when posts are absent" do
    it 'shows blank page', browser: :desktop do
      user = create(:user)
      login_as(user, scope: :user)
      visit "/posts"
      expect(page).to have_text('No results found')
    end
  end

  it_behaves_like 'shared_table' do
    let(:objects) { create_list(singular, 11, user: user) }
    let(:plural) { 'posts' }
    let(:singular) { 'post' }
    let(:user) { create(:user) }

    before do
      objects
      Post.__elasticsearch__.refresh_index!
      login_as(user, scope: :user)
    end
  end

  it_behaves_like 'shared_workspace' do
    let(:plural) { 'posts' }
    let(:user) { create(:user) }
    before do
      create(:post)
      Post.__elasticsearch__.refresh_index!
    end
  end
end
