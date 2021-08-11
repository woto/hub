# frozen_string_literal: true

require 'rails_helper'

describe Widgets::SimplesController, type: :system do
  let(:user) { create(:user) }
  let(:offer) { OfferCreator.call(feed_category: create(:feed_category)) }
  let!(:widget) { create(:simple_widget, user: user) }

  before do
    login_as(user, scope: :user)
    visit new_post_path(locale: :ru)

    within '.post_body' do
      click_on('Вставить виджет')
    end

    find("#widget-cover-#{widget.id}").click
    click_on('Редактировать виджет')

    expect(page).to have_text('Редактирование виджета')
  end

  context 'when page initially loaded' do
    it 'shows widget preview' do
      expect(page).to have_link('Перейти в магазин', href: widget.widgetable.url)
      expect(page).to have_link(widget.widgetable.title, href: widget.widgetable.url)
      expect(page).to have_text(widget.widgetable.body)
      expect(page).to have_css('img[src*="adriana_chechik"]')
    end

    it "prefills form's inputs" do
      expect(page).to have_field('URL', with: widget.widgetable.url)
      expect(page).to have_field('Название', with: widget.widgetable.title)
      expect(page).to have_field('Описание', with: widget.widgetable.body)
      expect(page).to have_css('img.img-thumbnail[src*="adriana_chechik"]')
    end
  end

  context 'when form filled correctly' do
    it 'updates widget' do
      widgets_count = Widget.count
      widgets_simples_count = Widgets::Simple.count
      pictures_count = ActiveStorage::Attachment.count

      fill_in 'URL', with: offer['url'][0][Import::Offers::Hashify::HASH_BANG_KEY]
      fill_in 'Название', with: 'Название товара'
      fill_in 'Описание', with: 'Описание товара'
      page.attach_file(file_fixture('jessa_rhodes.jpg')) do
        find('input[type="file"]').click
      end
      expect(page).to have_text('Файлы успешно загружены')
      click_on 'Сохранить виджет'
      expect(page).to have_text('Виджет успешно изменен')

      expect(Widget.count).to eq(widgets_count)
      expect(Widgets::Simple.count).to eq(widgets_simples_count)
      expect(ActiveStorage::Attachment.count).to eq(pictures_count + 1)

      expect(widget.widgetable.reload).to have_attributes(
        url: offer['url'][0][Import::Offers::Hashify::HASH_BANG_KEY],
        title: 'Название товара',
        body: 'Описание товара'
      )

      # TODO: How to move this validation in one line higher? Somehow like:
      # have_attributes(...., pictures: Widgets::Simples::Picture association)
      expect(widget.widgetable.pictures.last).to be_attached
      expect(widget.widgetable.pictures.last.picture.blob.filename).to eq('jessa_rhodes.jpg')
    end
  end

  context 'when form is not changed' do
    it 'saves form ' do
      click_on 'Сохранить виджет'
      expect(page).to have_text('Виджет успешно изменен')
    end
  end
end
