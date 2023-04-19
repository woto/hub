# frozen_string_literal: true

require 'rails_helper'

xdescribe Tables::OffersController, type: :system do
  it 'slides images on mousemove' do
    pictures = %w[megan_vale.jpg sasha_rose.jpeg angel_rivas.jpg]
    offer = OfferCreator.call(feed_category: FactoryBot.create(:feed_category), pictures: pictures)
    visit '/ru/offers'

    expect(page).to have_no_css("#carousel-controls-#{offer['_id'].parameterize}-1")
    page.execute_script "
      var element = document.getElementById('carousel-controls-#{offer['_id'].parameterize}');
      var event = new MouseEvent('mousemove', { clientX: 350 });
      element.dispatchEvent(event);
    "
    expect(page).to have_css("#carousel-controls-#{offer['_id'].parameterize}-1")

    expect(page).to have_no_css("#carousel-controls-#{offer['_id'].parameterize}-2")
    page.execute_script "
      var element = document.getElementById('carousel-controls-#{offer['_id'].parameterize}');
      var event = new MouseEvent('mousemove', { clientX: 400 });
      element.dispatchEvent(event);
    "
    expect(page).to have_css("#carousel-controls-#{offer['_id'].parameterize}-2")
  end

  context 'when two images' do
    it 'shows `carousel-indicators` elements' do
      pictures = %w[megan_vale.jpg sasha_rose.jpeg]
      offer = OfferCreator.call(feed_category: FactoryBot.create(:feed_category), pictures: pictures)
      visit '/ru/offers'

      within("#carousel-controls-#{offer['_id']}") do
        within('ol.carousel-indicators') do
          expect(page).to have_css('li', count: 2)
        end
      end
    end
  end

  context 'when one image' do
    it 'does not show `carousel-indicators` elements' do
      offer = OfferCreator.call(feed_category: FactoryBot.create(:feed_category), pictures: [])
      visit '/ru/offers'
      within("#carousel-controls-#{offer['_id']}") do
        expect(page).to have_no_css('ol.carousel-indicators')
      end
    end
  end
end
