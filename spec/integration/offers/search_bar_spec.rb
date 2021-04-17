# frozen_string_literal: true

require 'rails_helper'

describe Tables::OffersController, type: :system do
  let(:feed_category) { create(:feed_category) }
  let(:advertiser) { feed_category.feed.advertiser }
  let(:feed) { feed_category.feed }
  let(:q) { Faker::Alphanumeric.alphanumeric }

  def fill_search_input(text)
    field = find_field('Введите текст для поиска...')
    # this needed for workaround a problem with concatenating texts in input field
    # https://github.com/teamcapybara/capybara/issues/2419
    field.set('')
    field.set(text)
  end

  shared_examples 'includes item to search inside feed_category' do
    it 'includes item to search inside feed_category' do
      within('section.page') do
        fill_search_input(feed_category.to_label)
        click_button 'search-button'

        click_button %(В категории: "#{feed_category.to_label}")
        expect(page).to have_current_path(path)
      end
    end
  end

  shared_examples 'includes item to search inside feed' do
    it 'includes item to search inside feed' do
      within('section.page') do
        fill_search_input(feed.to_label)
        click_button 'search-button'

        click_button %(В прайс листе: "#{feed.to_label}")
        expect(page).to have_current_path(path)
      end
    end
  end

  shared_examples 'includes item to search inside advertiser' do
    it 'includes item to search inside advertiser' do
      within('section.page') do
        fill_search_input(advertiser.to_label)
        click_button 'search-button'

        click_button %(У рекламодателя: "#{advertiser.to_label}")
        expect(page).to have_current_path(path)
      end
    end
  end

  shared_examples 'includes item to search everywhere' do
    it 'includes item to search everywhere' do
      within('section.page') do
        fill_search_input('everywhere')
        click_button 'search-button'

        click_button 'Искать везде'
        expect(page).to have_current_path(path)
      end
    end
  end

  context 'when searches inside feed_category' do
    before do
      visit feed_category_offers_path(feed_category_id: feed_category.id, q: q, locale: 'ru')
    end

    describe 'includes item to search inside feed_category' do
      it_behaves_like 'includes item to search inside feed_category' do
        let(:path) do
          feed_category_offers_path(feed_category_id: feed_category.id, q: feed_category.to_label, locale: 'ru',
                                    per: 12, sort: :id, order: 'desc', only_path: true)
        end
      end
    end

    describe 'includes item to search inside feed' do
      it_behaves_like 'includes item to search inside feed' do
        let(:path) do
          feed_offers_path(feed_id: feed.id, q: feed.to_label, locale: 'ru', per: 12, sort: :id, order: 'desc',
                           only_path: true)
        end
      end
    end

    describe 'includes item to search inside advertiser' do
      it_behaves_like 'includes item to search inside advertiser' do
        let(:path) do
          advertiser_offers_path(advertiser_id: advertiser.id, q: advertiser.to_label, locale: 'ru', per: 12,
                                 sort: :id, order: 'desc', only_path: true)
        end
      end
    end

    describe 'includes item to search everywhere' do
      it_behaves_like 'includes item to search everywhere' do
        let(:path) do
          offers_path(q: 'everywhere', locale: 'ru', per: 12, sort: :id, order: 'desc', only_path: true)
        end
      end
    end
  end

  context 'when searches inside feed' do
    before do
      visit feed_offers_path(feed_id: feed.id, q: q, locale: 'ru')
    end

    describe 'includes item to search inside feed' do
      it_behaves_like 'includes item to search inside feed' do
        let(:path) do
          feed_offers_path(feed_id: feed.id, q: feed.to_label, locale: 'ru', per: 12, sort: :id, order: 'desc',
                           only_path: true)
        end
      end
    end

    describe 'includes item to search inside advertiser' do
      it_behaves_like 'includes item to search inside advertiser' do
        let(:path) do
          advertiser_offers_path(advertiser_id: advertiser.id, q: advertiser.to_label, locale: 'ru', per: 12,
                                 sort: :id, order: 'desc', only_path: true)
        end
      end
    end

    describe 'includes item to search everywhere' do
      it_behaves_like 'includes item to search everywhere' do
        let(:path) do
          offers_path(q: 'everywhere', locale: 'ru', per: 12, sort: :id, order: 'desc', only_path: true)
        end
      end
    end
  end

  context 'when searches inside advertiser' do
    before do
      visit advertiser_offers_path(advertiser_id: advertiser.id, q: q, locale: 'ru')
    end

    describe 'includes item to search inside advertiser' do
      it_behaves_like 'includes item to search inside advertiser' do
        let(:path) do
          advertiser_offers_path(advertiser_id: advertiser.id, q: advertiser.to_label, locale: 'ru', per: 12,
                                 sort: :id, order: 'desc', only_path: true)
        end
      end
    end

    describe 'includes item to search everywhere' do
      it_behaves_like 'includes item to search everywhere' do
        let(:path) do
          offers_path(q: 'everywhere', locale: 'ru', per: 12, sort: :id, order: 'desc', only_path: true)
        end
      end
    end
  end

  context 'when searches inside root' do
    describe 'shared_search_everywhere' do
      it_behaves_like 'shared_search_everywhere' do
        before { visit '/ru/offers' }

        let(:params) do
          { controller: 'tables/offers', q: q, locale: 'ru', per: 12, sort: :id, order: :desc, only_path: true }
        end
      end
    end
  end
end
