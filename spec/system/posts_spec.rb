# frozen_string_literal: true

require 'rails_helper'

describe PostsController do

  context 'when posts are present' do

    let!(:post) { create(:post) }

    before do
      login_as(post.user, scope: :user)
    end

    describe '#edit' do
      describe 'language_component' do
        before do
          visit edit_post_path(post, locale: 'ru')
        end

        it_behaves_like 'shared_language_component' do
          let(:link) { edit_post_path(post, locale: 'en') }
        end
      end
    end
  end
end
