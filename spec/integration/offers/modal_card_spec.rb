# frozen_string_literal: true

require 'rails_helper'

describe Tables::OffersController, type: :system do
  let!(:offer) { OfferCreator.call(feed_category: FactoryBot.create(:feed_category)) }
  let(:offer_url) { offer['url'][0][Import::Offers::Hashify::HASH_BANG_KEY] }

  before do
    visit '/ru/offers'
    within("#carousel-controls-#{offer['_id']}") do
      click_link
    end
  end

  it 'copies offer url to clipboard' do
    find('[data-action="clipboard#copy"]').click
    expect(page).to have_text('Ссылка успешно скопирована в буфер обмена')
    page.driver.browser.execute_cdp('Browser.grantPermissions',
                                    origin: page.server_url,
                                    permissions: ['clipboardReadWrite'])
    expect(page.evaluate_async_script('navigator.clipboard.readText().then(arguments[0])')).to eq(offer_url)
  end

  it 'shows correct data on modal card' do
    within('.modal-content') do
      within('.modal-title') do
        expect(page).to have_text("Информация о товаре: #{offer['_id']}")
      end

      within('.modal-body') do
        expect(page).to have_field(with: offer_url)
        expect(page).to have_text("Название: #{offer['name'][0][Import::Offers::Hashify::HASH_BANG_KEY]}")
        expect(page).to have_text("Описание:\n#{offer['description'][0][Import::Offers::Hashify::HASH_BANG_KEY]}")
        expect(page).to have_text("Цена: #{offer['price'][0][Import::Offers::Hashify::HASH_BANG_KEY]}")
        expect(page).to have_text("Рекламодатель: #{Advertiser.find(offer['advertiser_id']).name}")
        expect(page).to have_text("Прайс: #{Feed.find(offer['advertiser_id']).name}")
        expect(page).to have_text("Категория: #{FeedCategory.find(offer['advertiser_id']).name}")
        expect(page).to have_link('Перейти в магазин', href: offer['url'][0][Import::Offers::Hashify::HASH_BANG_KEY])
      end
    end
  end
end
