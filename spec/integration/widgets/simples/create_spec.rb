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
    # this timeouts relates to the issue https://github.com/hotwired/turbo-rails/issues/197
    sleep(1)
    click_link(href: '/ru/widgets/simples/new')
    sleep(1)
    expect(page).to have_text('Создание виджета')
  end

  context 'when page initially loaded' do
    it 'shows widget preview' do
      expect(page).to have_text('Пример названия оффера')
      expect(page).to have_css('img[src*="placeholder"]')
    end
  end

  context 'when form filled correctly' do
    it 'creates widget' do
      fill_in 'URL', with: offer['url'][0][Import::Offers::Hashify::HASH_BANG_KEY]
      fill_in 'Название', with: 'Название оффера'
      fill_in 'Описание', with: 'Описание оффера'
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
          .and(change(Widgets::Simples::Picture, :count))
          .and(change(ActiveStorage::Attachment, :count))
      )

      widgetable = Widgets::Simple.last

      expect(widgetable).to have_attributes(
        url: offer['url'][0][Import::Offers::Hashify::HASH_BANG_KEY],
        title: 'Название оффера',
        body: 'Описание оффера'
      )

      # TODO: How to move this validation in one line higher? Somehow like:
      # have_attributes(...., pictures: Widgets::Simples::Picture association)
      expect(widgetable.pictures.last).to be_attached
      expect(widgetable.pictures.last.picture.blob.filename).to eq('jessa_rhodes.jpg')
    end
  end

  context 'when form is not filled' do
    it 'shows errors ' do
      click_on 'Создать виджет'
      expect(page).to have_text('Невозможно сохранить. Пожалуйста заполните поля')
      expect(page).to have_css('#widgets_simple_url ~ .invalid-feedback', text: 'URL не может быть пустым')
      expect(page).to have_css('#widgets_simple_title ~ .invalid-feedback', text: 'Название не может быть пустым')
      expect(page).to have_css('#widgets_simple_pictures ~ .invalid-feedback', text: 'Изображения недостаточной длины')
    end
  end
end
