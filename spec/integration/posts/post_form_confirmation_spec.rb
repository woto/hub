# frozen_string_literal: true

require 'rails_helper'

describe PostsController, type: :system, responsible: :admin do

  shared_examples_for 'does not ask confirmation' do
    it 'does not ask confirmation' do
      sleep(0.3)
      click_on 'Личный кабинет'
      expect(page).to have_current_path('/ru/dashboard')
    end
  end

  shared_examples_for 'asks confirmation' do
    it 'asks confirmation' do
      within '.post_body' do
        find('trix-editor').click
        find('trix-editor').native.send_key('1')
      end

      accept_confirm('') do
        click_on 'Личный кабинет'
      end

      expect(page).to have_current_path('/ru/dashboard')
    end
  end

  before do
    login_as(Current.responsible, scope: :user)
  end

  context 'when post is new and body is touched and clicks on any link' do
    it_behaves_like 'asks confirmation' do
      before do
        visit new_post_path(locale: :ru)
      end
    end
  end

  context 'when post is new and body is not touched and clicks on any link' do
    it_behaves_like 'does not ask confirmation' do
      before do
        visit new_post_path(locale: :ru)
      end
    end
  end

  context 'when post is saved and body is touched and clicks on any link' do
    let(:post) { create(:post, user: Current.responsible) }

    it_behaves_like 'asks confirmation' do
      before do
        visit edit_post_path(post, locale: :ru)
      end
    end
  end

  context 'when post is saved and body is not touched and clicks on any link' do
    let(:post) { create(:post, user: Current.responsible) }

    it_behaves_like 'does not ask confirmation' do
      before do
        visit edit_post_path(post, locale: :ru)
      end
    end
  end
end
