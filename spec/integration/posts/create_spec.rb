
require 'rails_helper'

describe PostsController, type: :system do

  context 'when form submits' do
    let!(:post_category) { create(:post_category, realm: realm) }
    let(:realm) { create(:realm, kind: :post) }
    let(:user) { create(:user) }

    it 'does not ask confirmation and saves post' do
      login_as(user, scope: :user)
      visit new_post_path(locale: :ru)

      fill_in('post_title', with: 'Some title')

      within '.post_body' do
        find('trix-editor').click
        find('trix-editor').native.send_key('1')
      end

      within '.post_realm' do
        find('.selectize-input').click
        find('input').native.send_key(post_category.realm.to_label[..3])
        find('div.option', text: post_category.realm.to_label).click
      end

      within '.post_post_category' do
        find('.selectize-input').click
        find('input').native.send_key(post_category.to_label[..3])
        find('div.option', text: post_category.to_label).click
      end

      # NOTE: Old way to fill post category may be helpful later. Review
      # within('.post_post_category') do
      #   find('.selectize-input').click
      #   fill_in 'post_post_category_id-selectized', with: post_category.title[0..-2].to_s
      #   expect(page).to have_css('.has-options')
      #   find('#post_post_category_id-selectized').send_keys(:return)
      # end

      within '.post_tags' do
        find('.selectize-input').click
        find('input').native.send_key('tag')
        find('input').native.send_key(:enter)
      end

      select 'Russian Ruble', from: 'Валюта'

      choose 'модерация'

      expect do
        click_button('Сохранить')
        expect(page).to have_text('Статья была успешно создана')
      end.to change(user.posts, :count)
    end
  end
end
