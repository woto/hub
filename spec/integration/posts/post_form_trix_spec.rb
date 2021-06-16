# frozen_string_literal: true

require 'rails_helper'

describe PostsController, type: :system, responsible: :admin do
  let(:post) { create(:post, user: Current.responsible, body: 'a') }

  it 'translates `Bold` to the russian' do
    login_as(Current.responsible, scope: :user)
    visit new_post_path(locale: :ru)

    expect(page).to have_css('button[title="Жирный"]', text: 'Жирный')
  end

  it 'changes `post[body]` correctly' do
    login_as(Current.responsible, scope: :user)
    visit edit_post_path(post, locale: :ru)

    within '.post_body' do
      expect(page).to have_field('post[body]', with: "<div>a</div>", type: :hidden)

      find('trix-editor').click
      find('trix-editor').native.send_key('1')

      expect(page).to have_field('post[body]', with: "<div>a1</div>", type: :hidden)
    end
  end

  context 'when clicks on `Вставить виджет`' do
    it 'opens widgets modal' do
      login_as(Current.responsible, scope: :user)
      visit edit_post_path(post, locale: :ru)

      expect(page).to have_no_text 'Управление виджетами'

      within '.post_body' do
        click_on('Вставить виджет')
      end

      expect(page).to have_text 'Управление виджетами'
    end
  end
end

# NOTE: Here is another ways to change trix content. May be helpful someday
#
# def fill_in_trix_editor(id, with:)
#   find(:xpath, "//trix-editor[@id='#{id}']").click.set(with)
# end
#
# def find_trix_editor(id)
#   find(:xpath, "//*[@id='#{id}']", visible: false)
# end
