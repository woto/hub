# frozen_string_literal: true

require 'rails_helper'

describe PostCategories::ImportsController, type: :system do
  let(:user) { create(:user, role: :admin) }

  def login
    login_as(user, scope: :user)
    visit new_post_categories_import_path(locale: :ru)
  end

  context 'when form fields does not filled' do
    before { login }

    it 'shows form errors correctly' do
      login_as(user, scope: :user)
      visit new_post_categories_import_path(locale: :ru)
      click_on('Импортировать')
      expect(page).to have_text('Площадка не может быть пустым')
      expect(page).to have_text('URL имеет непредусмотренное значение и URL не может быть пустым')
    end
  end

  context 'when form fields filled correctly' do
    let!(:realm) { create(:realm, kind: :post) }

    before { login }

    it 'queues import job' do
      within '.post_categories_import_realm_id' do
        find('.selectize-input').click
        find('input').native.send_key(realm.to_label[..3])
        find('div.option', text: realm.to_label).click
      end

      fill_in('post_categories_import_url',
              with: 'http://www.google.com/basepages/producttype/taxonomy-with-ids.de-DE.xls')

      expect do
        click_on('Импортировать')
        expect(page).to have_text('Задача импорта категорий успешно поставлена в очередь')
      end.to have_enqueued_job(PostCategories::GoogleMerchantImportJob)
    end
  end
end
