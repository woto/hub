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
    end
  end
end
