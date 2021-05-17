# frozen_string_literal: true

require 'rails_helper'

describe Tables::OffersController, type: :system, responsible: :admin do
  describe 'GET /offers' do
    describe 'offer star' do
      it_behaves_like 'favorites_initial_starred' do
        before do
          favorite = create(:favorite, user: Current.responsible, kind: 'offers')
          create(:favorites_item, ext_id: starred_object['_id'], kind: '_id', favorite: favorite)
          login_as(Current.responsible, scope: :user)
          visit offers_path
        end

        let(:starred) { "favorite-_id-#{starred_object['_id']}" }
        let(:starred_object) do
          OfferCreator.call(feed_category: create(:feed_category))
        end
      end

      it_behaves_like 'favorites_initial_unstarred' do
        before do
          visit offers_path
        end

        let(:unstarred) { "favorite-_id-#{unstarred_object['_id']}" }
        let(:unstarred_object) do
          OfferCreator.call(feed_category: create(:feed_category))
        end
      end
    end

    describe 'advertiser star' do
      it_behaves_like 'favorites_initial_starred' do
        before do
          feed = create(:feed, advertiser: starred_object)
          OfferCreator.call(feed_category: create(:feed_category, feed: feed))

          favorite = create(:favorite, user: Current.responsible, kind: 'offers')
          create(:favorites_item, ext_id: starred_object.id, kind: 'advertiser_id', favorite: favorite)
          login_as(Current.responsible, scope: :user)
          visit offers_path
        end

        let(:starred) { "favorite-advertiser_id-#{starred_object.id}" }
        let(:starred_object) { create(:advertiser) }

      end

      it_behaves_like 'favorites_initial_unstarred' do
        before do
          feed = create(:feed, advertiser: unstarred_object)
          OfferCreator.call(feed_category: create(:feed_category, feed: feed))

          visit offers_path
        end

        let(:unstarred) { "favorite-advertiser_id-#{unstarred_object.id}" }
        let(:unstarred_object) do
          create(:advertiser)
        end
      end
    end
  end

  describe 'GET /advertisers/:id/offers' do
    describe 'advertiser star' do
      it_behaves_like 'favorites_initial_starred' do
        before do
          feed = create(:feed, advertiser: starred_object)
          OfferCreator.call(feed_category: create(:feed_category, feed: feed))

          favorite = create(:favorite, user: Current.responsible, kind: 'offers')
          create(:favorites_item, ext_id: starred_object.id, kind: 'advertiser_id', favorite: favorite)
          login_as(Current.responsible, scope: :user)
          visit advertiser_offers_path(advertiser_id: starred_object.id)
        end

        let(:starred) { "favorite-advertiser_id-#{starred_object.id}" }
        let(:starred_object) { create(:advertiser) }
      end

      it_behaves_like 'favorites_initial_unstarred' do
        before do
          feed = create(:feed, advertiser: unstarred_object)
          OfferCreator.call(feed_category: create(:feed_category, feed: feed))

          login_as(Current.responsible, scope: :user)
          visit advertiser_offers_path(advertiser_id: unstarred_object.id)
        end

        let(:unstarred) { "favorite-advertiser_id-#{unstarred_object.id}" }
        let(:unstarred_object) { create(:advertiser) }
      end
    end

    describe 'feed star' do
      it_behaves_like 'favorites_initial_starred' do
        before do
          OfferCreator.call(feed_category: create(:feed_category, feed: starred_object))

          favorite = create(:favorite, user: Current.responsible, kind: 'offers')
          create(:favorites_item, ext_id: starred_object.id, kind: 'feed_id', favorite: favorite)
          login_as(Current.responsible, scope: :user)
          visit advertiser_offers_path(advertiser_id: starred_object.advertiser.id)
        end

        let(:starred) { "favorite-feed_id-#{starred_object.id}" }
        let(:starred_object) { create(:feed) }
      end

      it_behaves_like 'favorites_initial_unstarred' do
        before do
          OfferCreator.call(feed_category: create(:feed_category, feed: unstarred_object))

          login_as(Current.responsible, scope: :user)
          visit advertiser_offers_path(advertiser_id: unstarred_object.advertiser.id)
        end

        let(:unstarred) { "favorite-feed_id-#{unstarred_object.id}" }
        let(:unstarred_object) { create(:feed) }
      end
    end

    describe 'offer star' do
      it_behaves_like 'favorites_initial_starred' do
        before do
          favorite = create(:favorite, user: Current.responsible, kind: 'offers')
          create(:favorites_item, ext_id: starred_object['_id'], kind: '_id', favorite: favorite)
          login_as(Current.responsible, scope: :user)
          visit advertiser_offers_path(advertiser_id: starred_object['advertiser_id'])
        end

        let(:starred) { "favorite-_id-#{starred_object['_id']}" }
        let(:starred_object) do
          OfferCreator.call(feed_category: create(:feed_category))
        end
      end

      it_behaves_like 'favorites_initial_unstarred' do
        before do
          visit advertiser_offers_path(advertiser_id: unstarred_object['advertiser_id'])
        end

        let(:unstarred) { "favorite-_id-#{unstarred_object['_id']}" }
        let(:unstarred_object) do
          OfferCreator.call(feed_category: create(:feed_category))
        end
      end
    end
  end

  describe 'GET /feeds/:id/offers' do
    describe 'feed_star' do
      it_behaves_like 'favorites_initial_starred' do
        before do
          OfferCreator.call(feed_category: create(:feed_category, feed: starred_object))

          favorite = create(:favorite, user: Current.responsible, kind: 'offers')
          create(:favorites_item, ext_id: starred_object.id, kind: 'feed_id', favorite: favorite)
          login_as(Current.responsible, scope: :user)
          visit feed_offers_path(feed_id: starred_object.id)
        end

        let(:starred) { "favorite-feed_id-#{starred_object.id}" }
        let(:starred_object) { create(:feed) }
      end

      it_behaves_like 'favorites_initial_unstarred' do
        before do
          OfferCreator.call(feed_category: create(:feed_category, feed: unstarred_object))

          login_as(Current.responsible, scope: :user)
          visit feed_offers_path(feed_id: unstarred_object.id)
        end

        let(:unstarred) { "favorite-feed_id-#{unstarred_object.id}" }
        let(:unstarred_object) { create(:feed) }
      end
    end

    describe 'feed_category star' do
      it_behaves_like 'favorites_initial_starred' do
        before do
          OfferCreator.call(feed_category: starred_object)

          favorite = create(:favorite, user: Current.responsible, kind: 'offers')
          create(:favorites_item, ext_id: starred_object.id, kind: 'feed_category_id', favorite: favorite)
          login_as(Current.responsible, scope: :user)
          visit feed_offers_path(feed_id: starred_object.id)
        end

        let(:starred) { "favorite-feed_category_id-#{starred_object.id}" }
        let(:starred_object) { create(:feed_category) }
      end

      it_behaves_like 'favorites_initial_unstarred' do
        before do
          OfferCreator.call(feed_category: unstarred_object)

          login_as(Current.responsible, scope: :user)
          visit feed_offers_path(feed_id: unstarred_object.id)
        end

        let(:unstarred) { "favorite-feed_category_id-#{unstarred_object.id}" }
        let(:unstarred_object) { create(:feed_category) }
      end
    end

    describe 'offer star' do
      it_behaves_like 'favorites_initial_starred' do
        before do
          favorite = create(:favorite, user: Current.responsible, kind: 'offers')
          create(:favorites_item, ext_id: starred_object['_id'], kind: '_id', favorite: favorite)
          login_as(Current.responsible, scope: :user)
          visit feed_offers_path(feed_id: starred_object['feed_id'])
        end

        let(:starred) { "favorite-_id-#{starred_object['_id']}" }
        let(:starred_object) do
          OfferCreator.call(feed_category: create(:feed_category))
        end
      end

      it_behaves_like 'favorites_initial_unstarred' do
        before do
          visit feed_offers_path(feed_id: unstarred_object['feed_id'])
        end

        let(:unstarred) { "favorite-_id-#{unstarred_object['_id']}" }
        let(:unstarred_object) do
          OfferCreator.call(feed_category: create(:feed_category))
        end
      end
    end
  end

  describe 'GET /feed_categories/:id/offers' do
    describe 'parent feed_category star' do
      it_behaves_like 'favorites_initial_starred' do
        before do
          OfferCreator.call(feed_category: starred_object)

          favorite = create(:favorite, user: Current.responsible, kind: 'offers')
          create(:favorites_item, ext_id: starred_object.id, kind: 'feed_category_id', favorite: favorite)
          login_as(Current.responsible, scope: :user)
          visit feed_category_offers_path(feed_category_id: starred_object.id)
        end

        let(:starred) { "favorite-feed_category_id-#{starred_object.id}" }
        let(:starred_object) { create(:feed_category) }
      end

      it_behaves_like 'favorites_initial_unstarred' do
        before do
          OfferCreator.call(feed_category: unstarred_object)

          login_as(Current.responsible, scope: :user)
          visit feed_category_offers_path(feed_category_id: unstarred_object.id)
        end

        let(:unstarred) { "favorite-feed_category_id-#{unstarred_object.id}" }
        let(:unstarred_object) { create(:feed_category) }
      end
    end
  end
end
