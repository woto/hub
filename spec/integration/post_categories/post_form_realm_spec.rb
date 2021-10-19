# frozen_string_literal: true

require 'rails_helper'

describe PostCategoriesController, type: :system do
  let(:parent_category) { create(:post_category) }
  let(:child_category) { create(:post_category, parent: parent_category, realm: parent_category.realm) }
  let(:user) { create(:user, role: :admin) }

  before do
    login_as(user, scope: :user)
  end

  context 'when realm changes at the new post category (category is empty)' do
    let!(:realm) { create(:realm) }

    it 'does not ask confirmation and changes realm' do
      visit new_post_category_path(locale: :ru)
      expect(page).to have_select('post_category[realm_id]', visible: :hidden, selected: '')

      within '.post_category_realm' do
        find('.selectize-input').click
        find('input').native.send_key(realm.to_label[..3])
        find('div.option', text: realm.to_label).click
      end

      expect(page).to have_select('post_category[realm_id]', visible: :hidden, selected: realm.to_label)
    end
  end

  context 'when realm changes previous realm' do
    let!(:realm) { create(:realm, locale: :ru) }
    let!(:another_realm) { create(:realm, locale: :en) }

    it 'does not ask confirmation' do
      visit new_post_category_path(locale: :ru)
      expect(page).to have_select('post_category[realm_id]', visible: :hidden, selected: '')

      within '.post_category_realm' do
        find('.selectize-input').click
        find('input').native.send_key(realm.to_label[..3])
        find('div.option', text: realm.to_label).click
      end

      expect(page).to have_select('post_category[realm_id]', visible: :hidden, selected: realm.to_label)

      within '.post_category_realm' do
        find('.selectize-input').click
        find('input').native.send_key(another_realm.to_label[..3])
        find('div.option', text: another_realm.to_label).click
      end

      expect(page).to have_select('post_category[realm_id]', visible: :hidden, selected: another_realm.to_label)
    end
  end

  context 'when user tries to change realm and rejects the change' do
    it 'restores previously setted realm' do
      visit edit_post_category_path(child_category, locale: :ru)
      expect(page).to have_select('post_category[realm_id]', visible: :hidden, selected: child_category.realm.to_label)

      within('.post_category_realm') do
        find('.selectize-input').click
        dismiss_confirm('Вы уверены? Настройки родительской категории будут сброшены') do
          sleep(0.3)
          find('input').native.send_key(:backspace)
          sleep(0.3)
        end
      end

      expect(page).to have_select('post_category[realm_id]', visible: :hidden, selected: child_category.realm.to_label)
    end
  end

  context 'when realm changes at the post category which is saved (parent post category is filled)' do
    let!(:realm) { create(:realm, title: 'iiiii') }

    before do
      visit edit_post_category_path(child_category, locale: :ru)
    end

    it 'asks confirmation, changes the realm and clears parent post category' do
      expect(page).to have_select('post_category[realm_id]', visible: :hidden, selected: child_category.realm.to_label)
      expect(page).to have_select('post_category[parent_id]', visible: :hidden, selected: parent_category.to_label)

      within('.post_category_realm') do
        find('.selectize-input').click
        accept_confirm('Вы уверены? Настройки родительской категории будут сброшены') do
          sleep(0.3)
          find('input').native.send_key(:backspace)
          sleep(0.3)
        end
        find('input').native.send_key(realm.to_label[..3])
        find('div.option', text: realm.to_label).click
      end

      expect(page).to have_select('post_category[realm_id]', visible: :hidden, selected: realm.to_label)
      expect(page).to have_select('post_category[parent_id]', visible: :hidden, selected: '')
    end
  end

  context 'when realm changes at the new post category, but the parent category of the category has been changed' do
    let!(:realm) { create(:realm, locale: 'ru') }
    let!(:another_realm) { create(:realm, locale: 'en') }
    let!(:post_category) { create(:post_category, realm: realm) }

    it 'asks confirmation and clears parent post category' do
      visit new_post_category_path(locale: :ru)

      within '.post_category_realm' do
        find('.selectize-input').click
        find('input').native.send_key(realm.to_label[..3])
        find('div.option', text: realm.to_label).click
      end

      expect(page).to have_select('post_category[realm_id]', visible: :hidden, selected: realm.to_label)
      expect(page).to have_select('post_category[parent_id]', visible: :hidden, selected: '')

      within '.post_category_parent_id' do
        find('.selectize-input').click
        find('input').native.send_key(post_category.to_label[..3])
        find('div.option', text: post_category.to_label).click
      end

      expect(page).to have_select('post_category[parent_id]', visible: :hidden, selected: post_category.to_label)

      within '.post_category_realm' do
        find('.selectize-input').click
        accept_confirm('Вы уверены? Настройки родительской категории будут сброшены') do
          sleep(0.3)
          find('input').native.send_key(:backspace)
          sleep(0.3)
        end
        find('input').native.send_key(another_realm.to_label[..3])
        find('div.option', text: another_realm.to_label).click
      end

      expect(page).to have_select('post_category[realm_id]', visible: :hidden, selected: another_realm.to_label)
      expect(page).to have_select('post_category[parent_id]', visible: :hidden, selected: '')
    end
  end
end
