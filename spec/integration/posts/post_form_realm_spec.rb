# frozen_string_literal: true

require 'rails_helper'

describe PostsController, type: :system, responsible: :admin do
  let(:post) { create(:post, user: Current.responsible) }

  before do
    login_as(Current.responsible, scope: :user)
  end

  context 'when realm changes at the new post (category and tags are empty)' do
    let!(:realm) { create(:realm) }

    it 'does not ask confirmation and changes realm' do
      visit new_post_path(locale: :ru)
      expect(page).to have_select('post[realm_id]', visible: :hidden, selected: '')

      within '.post_realm' do
        find('.selectize-input').click
        find('input').native.send_key(realm.to_label[..3])
        find('div.option', text: realm.to_label).click
      end

      expect(page).to have_select('post[realm_id]', visible: :hidden, selected: realm.to_label)
    end
  end

  context 'when realm changes previous realm but category and tags are empty' do
    let!(:realm) { create(:realm, locale: :ru) }
    let!(:another_realm) { create(:realm, locale: :en) }

    it 'does not ask confirmation' do
      visit new_post_path(locale: :ru)
      expect(page).to have_select('post[realm_id]', visible: :hidden, selected: '')

      within '.post_realm' do
        find('.selectize-input').click
        find('input').native.send_key(realm.to_label[..3])
        find('div.option', text: realm.to_label).click
      end

      expect(page).to have_select('post[realm_id]', visible: :hidden, selected: realm.to_label)

      within '.post_realm' do
        find('.selectize-input').click
        find('input').native.send_key(another_realm.to_label[..3])
        find('div.option', text: another_realm.to_label).click
      end

      expect(page).to have_select('post[realm_id]', visible: :hidden, selected: another_realm.to_label)
    end
  end

  context 'when user tries to change realm and rejects the change' do
    it 'restores previously setted realm' do
      visit edit_post_path(post, locale: :ru)
      expect(page).to have_select('post[realm_id]', visible: :hidden, selected: post.realm.to_label)

      within('.post_realm') do
        find('.selectize-input').click
        dismiss_confirm('Вы уверены? Настройки категории и тегов будут сброшены') do
          sleep(0.3)
          find('input').native.send_key(:backspace)
          sleep(0.3)
        end
      end

      expect(page).to have_select('post[realm_id]', visible: :hidden, selected: post.realm.to_label)
    end
  end

  context 'when realm changes at the post which is saved (category and tags are filled)' do
    let!(:realm) { create(:realm, title: 'iiiii') }

    before do
      visit edit_post_path(post, locale: :ru)
    end

    it 'asks confirmation, changes the realm and clears post category and tags' do
      expect(page).to have_select('post[realm_id]', visible: :hidden, selected: post.realm.to_label)
      expect(page).to have_select('post[post_category_id]', visible: :hidden, selected: post.post_category.to_label)
      expect(page).to have_select('post[tags][]', visible: :hidden, selected: post.tags)

      within('.post_realm') do
        find('.selectize-input').click
        accept_confirm('Вы уверены? Настройки категории и тегов будут сброшены') do
          sleep(0.3)
          find('input').native.send_key(:backspace)
          sleep(0.3)
        end
        find('input').native.send_key(realm.to_label[..3])
        find('div.option', text: realm.to_label).click
      end

      expect(page).to have_select('post[realm_id]', visible: :hidden, selected: realm.to_label)
      expect(page).to have_select('post[post_category_id]', visible: :hidden, selected: '')
      expect(page).to have_select('post[tags][]', visible: :hidden, selected: nil)
    end
  end

  context 'when realm changes at the new post, but the category of the post has been changed' do
    let!(:realm) { create(:realm) }
    let!(:another_realm) { create(:realm) }
    let(:post_category) { create(:post_category, realm: realm) }

    it 'asks confirmation and clears post category' do
      visit new_post_path(locale: :ru)

      within '.post_realm' do
        find('.selectize-input').click
        find('input').native.send_key(realm.to_label[..3])
        find('div.option', text: realm.to_label).click
      end

      expect(page).to have_select('post[realm_id]', visible: :hidden, selected: realm.to_label)
      expect(page).to have_select('post[post_category_id]', visible: :hidden, selected: '')

      within '.post_post_category' do
        find('.selectize-input').click
        find('input').native.send_key(post_category.to_label[..3])
        find('div.option', text: post_category.to_label).click
      end

      expect(page).to have_select('post[post_category_id]', visible: :hidden, selected: post_category.to_label)

      within '.post_realm' do
        find('.selectize-input').click
        accept_confirm('Вы уверены? Настройки категории и тегов будут сброшены') do
          sleep(0.3)
          find('input').native.send_key(:backspace)
          sleep(0.3)
        end
        find('input').native.send_key(another_realm.to_label[..3])
        find('div.option', text: another_realm.to_label).click
      end

      expect(page).to have_select('post[realm_id]', visible: :hidden, selected: another_realm.to_label)
      expect(page).to have_select('post[post_category_id]', visible: :hidden, selected: '')
    end
  end

  context 'when realm changes at the new post, but the tags of the post has been changed' do
    let!(:realm) { create(:realm, kind: :news) }
    let!(:another_realm) { create(:realm, kind: :post) }

    it 'asks confirmation and clears post tags' do
      visit new_post_path(locale: :ru)

      within '.post_realm' do
        find('.selectize-input').click
        find('input').native.send_key(realm.to_label[..3])
        find('div.option', text: realm.to_label).click
      end

      expect(page).to have_select('post[realm_id]', visible: :hidden, selected: realm.to_label)
      expect(page).to have_select('post[tags][]', visible: :hidden, selected: nil)

      within '.post_tags' do
        find('.selectize-input').click
        find('input').native.send_key('tag')
        find('input').native.send_key(:enter)
      end

      expect(page).to have_select('post[tags][]', visible: :hidden, selected: 'tag')

      within '.post_realm' do
        find('.selectize-input').click
        accept_confirm('Вы уверены? Настройки категории и тегов будут сброшены') do
          sleep(0.3)
          find('input').native.send_key(:backspace)
          sleep(0.3)
        end
        find('input').native.send_key(another_realm.to_label[..3])
        find('div.option', text: another_realm.to_label).click
      end

      expect(page).to have_select('post[realm_id]', visible: :hidden, selected: another_realm.to_label)
      expect(page).to have_select('post[tags][]', visible: :hidden, selected: nil)
    end
  end
end
