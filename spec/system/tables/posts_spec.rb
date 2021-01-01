# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tables::PostsController do

  context 'when posts are present' do

    let!(:post) { create(:post) }
    let!(:plural) { 'posts' }
    let!(:user) { post.user }
    let!(:singular) { 'post' }
    let!(:objects) { create_list(singular, 10, user: user) }

    before do
      login_as(post.user, scope: :user)
    end

    describe '#index' do
      before do
        visit "/posts"
      end

      it "shows row" do
        expect(page).to have_css("#table_post_#{post.id}")
        expect(Post.count).to eq(11)
      end
    end

    it_behaves_like 'shared_table'

    it_behaves_like 'shared_workspace' do
      let(:cols) { '0.6.5.16.13' }
    end
  end

  context "when posts are absent" do
    describe '#index' do
      before do
        user = create(:user)
        login_as(user, scope: :user)
        visit "/posts"
      end

      it 'shows blank page' do
        expect(page).to have_text('No results found')
      end
    end
  end
end
