# frozen_string_literal: true

require 'rails_helper'

describe Tables::OffersController, type: :system do
  describe 'shared_language_component' do
    it_behaves_like 'shared_language_component' do
      before do
        visit offers_path
      end

      let(:link) { offers_path(locale: 'en') }
    end
  end

  describe 'shared_search_everywhere' do
    it_behaves_like 'shared_search_everywhere' do
      before do
        feed = create(:feed, xml_file_path: file_fixture('feeds/yml-custom.xml'))
        Feeds::Parse.call(feed: feed)
        elastic_client.indices.refresh
        visit '/ru/offers'
      end

      let(:params) do
        { controller: 'tables/offers', q: q, locale: 'ru',
          per: 12, sort: :id, order: :desc, only_path: true }
      end
    end
  end

  describe '#index' do
    describe 'TODO' do
      describe 'shared_favorites_unauthenticated' do
        it_behaves_like 'shared_favorites_unauthenticated' do
          before do
            feed = create(:feed, xml_file_path: file_fixture('feeds/yml-custom.xml'))
            Feeds::Parse.call(feed: feed)
            elastic_client.indices.refresh

            visit '/ru/offers'
            click_on("favorite-5678-#{feed.id}")
          end
        end
      end

      context 'previous' do
        let!(:advertiser) { create(:advertiser) }
        let!(:feed) do
          create(:feed, advertiser: advertiser, xml_file_path: file_fixture('feeds/yml-custom.xml'))
        end

        let(:q1) { 'Вафельница' }
        let(:q2) { 'Мороженица' }
        let(:small_household_appliances) { feed.feed_categories.find_by(ext_id: '10') }

        before do
          Feeds::Parse.call(feed: feed)
          elastic_client.indices.refresh
        end

        context 'when is on "feed offers" page' do
          before do
            visit feed_offers_path(feed_id: feed.slug_with_advertiser, locale: 'ru', q: q1)
          end

          it 'clicking on "search inside this feed" leads to correct address' do
            within('section.page') do
              fill_in 'Введите текст для поиска...', with: q2
              click_button 'search-button'

              expect(page).to have_button('search-everywhere')
              expect(page).to have_button('search-feed')
              expect(page).not_to have_button('search-category')

              click_button('search-feed')

              expect(page).to have_current_path(
                feed_offers_path(feed_id: feed.slug_with_advertiser, q: q2, locale: 'ru', per: 12,
                                 sort: :id, order: 'desc', only_path: true),
                url: false
              )
            end
          end
        end

        context 'when is on "category offers" page' do
          before do
            visit feed_offers_path(feed_id: feed.slug_with_advertiser,
                                   category_id: small_household_appliances.id,
                                   q: q1, locale: 'ru')
          end

          it 'clicking on "search inside this category" leads to correct address' do
            within('section.page') do
              # this line is needed for workaround a problem with concatenating q1 + q2
              # very likely it is a Capybara bug
              # https://github.com/teamcapybara/capybara/issues/2419
              find('[data-target="search-offers.searchText"]').set('')

              fill_in 'Введите текст для поиска...', with: q2
              click_button 'search-button'

              expect(page).to have_button('search-everywhere')
              expect(page).to have_button('search-feed')
              expect(page).to have_button('search-category')

              click_button('search-category')

              expect(page).to have_current_path(
                feed_offers_path(feed_id: feed.slug_with_advertiser, category_id: small_household_appliances.id,
                                 q: q2, per: 12, sort: :id, order: 'desc', locale: 'ru', only_path: true),
                url: false
              )
            end
          end
        end
      end
    end
  end
end
