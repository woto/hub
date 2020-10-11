# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Trix `dirty` feature' do
  let!(:user) { create(:user) }
  let!(:post) { create(:post, user: user) }

  before do
    login_as(user, scope: :user)
    Post.__elasticsearch__.refresh_index!
  end

  def fill_in_trix_editor(id, with:)
    find(:xpath, "//trix-editor[@id='#{id}']").click.set(with)
  end

  def find_trix_editor(id)
    find(:xpath, "//*[@id='#{id}']", visible: false)
  end

  context 'when trix were not touched' do
    context 'when post is new' do
      it 'does not ask confirmation' do
        visit '/ru/posts/new'
        click_on 'Дашборд'
        expect(page).to have_current_path('/ru/dashboard')
      end
    end

    context 'when post is old' do
      it 'does not ask confirmation' do
        visit "/ru/posts/#{post.id}/edit"
        expect(find_trix_editor('post_body').value).to eq("<div>#{post.body.body.to_html}</div>")
        expect(page).to have_field('post_title', with: post.title)
        click_on 'Дашборд'
        expect(page).to have_current_path('/ru/dashboard')
      end
    end
  end

  context 'when trix were touched' do
    context 'when accepts confirm' do
      it 'redirects to new page' do
        visit '/ru/posts/new'
        fill_in_trix_editor('post_body', with: 'Some text')
        accept_confirm do
          click_on 'Дашборд'
        end
        expect(page).to have_current_path('/ru/dashboard')
      end
    end

    context 'when rejects confirm' do
      it 'stays on same page' do
        visit '/ru/posts/new'
        fill_in_trix_editor('post_body', with: 'Some text')
        dismiss_confirm do
          click_on 'Дашборд'
        end
        expect(page).to have_current_path('/ru/posts/new')
      end
    end

    context 'when form submits' do
      it 'does not ask confirmation and saves post' do
        visit '/ru/posts/new'
        fill_in_trix_editor('post_body', with: 'Some text')
        fill_in('post_title', with: 'Some title')
        expect do
          click_button('Создать Post')
          expect(page).to have_text('Post was successfully created.')
        end.to change(user.posts, :count)
      end
    end
  end
end
