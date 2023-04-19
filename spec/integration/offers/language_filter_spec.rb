# frozen_string_literal: true

require 'rails_helper'

xdescribe Tables::OffersController, type: :system do
  it 'simply shows language filter' do
    feed_category = create(:feed_category)
    OfferCreator.call(feed_category: feed_category, name: 'Название товара', description: 'Это просто описание товара')
    Import::AggregateLanguage.call(feed: feed_category.feed)
    visit offers_path

    expect(page).to have_css('label#feeds-language-filter-ru')
  end

  # rubocop:disable RSpec/MultipleMemoizedHelpers
  context 'when there are more than 5 languages to filter' do
    let(:russian_feed_category) { create(:feed_category) }
    let(:greek_feed_category) { create(:feed_category) }
    let(:english_feed_category) { create(:feed_category) }
    let(:chinese_feed_category) { create(:feed_category) }
    let(:italian_feed_category) { create(:feed_category) }
    let(:spanish_feed_category) { create(:feed_category) }

    before do
      data = [
        { name: 'Название товара',
          description: 'Это просто описание товара',
          feed_category: russian_feed_category },
        { name: 'Ονομασία Προϊόντος',
          description: 'Αυτή είναι μια απλή περιγραφή του προϊόντος',
          feed_category: greek_feed_category },
        { name: 'Product name',
          description: 'This is a simple product description',
          feed_category: english_feed_category },
        { name: '产品名称',
          description: '这是一个简单的产品描述',
          feed_category: chinese_feed_category },
        { name: "Nome dell'articolo",
          description: 'Questa è una semplice descrizione del prodotto',
          feed_category: italian_feed_category }
      ]
      data.each do |rec|
        2.times do
          OfferCreator.call(name: rec[:name],
                            feed_category: rec[:feed_category],
                            description: rec[:description])
        end
      end

      OfferCreator.call(name: 'Nombre del artículo',
                        feed_category: spanish_feed_category,
                        description: 'Esta es una descripción simple del producto')
      visit offers_path
    end

    it 'includes most popular languages' do
      expect(page).to have_css('label#feeds-language-filter-ru')
      expect(page).to have_css('label#feeds-language-filter-el')
      expect(page).to have_css('label#feeds-language-filter-en')
      expect(page).to have_css('label#feeds-language-filter-zh')
      expect(page).to have_css('label#feeds-language-filter-it')
    end

    it 'does not include least popular languages' do
      expect(page).not_to have_css('label#feeds-language-filter-es')
    end

    context "when clicks on '...'" do
      it 'expand least popular languages' do
        expect(page).not_to have_css('label#feeds-language-filter-es')
        click_link('...')
        expect(page).to have_css('label#feeds-language-filter-es')
      end
    end

    context 'when selects Russian and English languages and proceeds with Ok' do
      it 'filters feeds by those languages' do
        check('English', allow_label_click: true)
        check('Russian', allow_label_click: true)
        click_button('Ok')
        expect(page).to have_link("Advertiser: #{russian_feed_category.feed.advertiser.to_label}")
        expect(page).to have_link("Advertiser: #{english_feed_category.feed.advertiser.to_label}")
        expect(page).not_to have_link("Advertiser: #{italian_feed_category.feed.advertiser.to_label}")
      end
    end
  end
  # rubocop:enable RSpec/MultipleMemoizedHelpers
end
