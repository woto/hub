# frozen_string_literal: true

require 'rails_helper'

describe Widgets::SimplesController, type: :system do
  let(:user) { create(:user) }
  let(:offer) { OfferCreator.call(feed_category: create(:feed_category)) }

  before do
    login_as(user, scope: :user)
    visit new_post_path(locale: :ru)

    within '.post_body' do
      click_on('Вставить виджет')
    end

    click_on('Создать новый виджет')
    click_link(href: '/ru/widgets/simples/new')
    expect(page).to have_text('Создание виджета')
  end

  context 'when page initially loaded' do
    it 'shows widget preview' do
      expect(page).to have_text('Пример названия товара')
      expect(page).to have_text('Яркий и информативный пример описания, содержащий основные характеристики товара')
      expect(page).to have_css('img[src*="placeholder"]')
    end
  end

  context 'when form filled correctly' do
    it 'creates widget' do
      fill_in 'URL', with: offer['url'][0][Import::Offers::Hashify::HASH_BANG_KEY]
      fill_in 'Название', with: 'Название товара'
      fill_in 'Описание', with: 'Описание товара'
      page.attach_file(file_fixture('jessa_rhodes.jpg')) do
        find('input[type="file"]').click
      end
      expect(page).to have_text('Файлы успешно загружены')
      expect do
        click_on 'Создать виджет'
        expect(page).to have_text('Виджет успешно создан')
      end.to(
        change(Widget, :count)
          .and(change(Widgets::Simple, :count))
          .and(change(ActiveStorage::Attachment, :count))
      )

      widgetable = Widgets::Simple.last

      expect(widgetable).to have_attributes(
        url: offer['url'][0][Import::Offers::Hashify::HASH_BANG_KEY],
        title: 'Название товара',
        body: 'Описание товара',
        pictures: be_attached
      )
    end
  end

  context 'when form is not filled' do
    it 'shows errors ' do
      click_on 'Создать виджет'
      expect(page).to have_text('Невозможно сохранить. Пожалуйста заполните поля')
      expect(page).to have_css('#widgets_simple_url ~ .invalid-feedback', text: 'URL не может быть пустым')
      expect(page).to have_css('#widgets_simple_title ~ .invalid-feedback', text: 'Название не может быть пустым')
      expect(page).to have_css('#widgets_simple_body ~ .invalid-feedback', text: 'Описание не может быть пустым')
      expect(page).to have_css('#widgets_simple_pictures ~ .invalid-feedback', text: 'Изображения недостаточной длины')
    end
  end
end
