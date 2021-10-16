# frozen_string_literal: true

require 'rails_helper'

describe Tables::OffersController, type: :request do
  let!(:feed_category) { create(:feed_category) }
  let!(:feed) { feed_category.feed }
  let!(:advertiser) { feed.advertiser }

  shared_examples 'multi' do
    context 'when there are no any offer' do
      specify do
        get path.call({})
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when there are any offers' do
      let!(:offer) { OfferCreator.call(feed_category: feed_category) }

      context 'when offer include on the first page' do
        specify do
          get path.call(page: 1)
          expect(response).to have_http_status(:ok)
        end
      end

      context 'when offer does not include on the second page' do
        specify do
          get path.call(page: 2)
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end

  describe 'GET /offers' do
    let(:path) { ->(params) { offers_path(params) } }

    it_behaves_like 'multi'
  end

  describe 'GET /advertisers/:advertiser_id/offers' do
    let(:path) { ->(params) { advertiser_offers_path(params.merge(advertiser_id: advertiser.id)) } }

    it_behaves_like 'multi'
  end

  describe 'GET /feeds/:feed_id/offers' do
    let(:path) { ->(params) { feed_offers_path(params.merge(feed_id: feed.id)) } }

    it_behaves_like 'multi'
  end

  describe 'GET /feed_categories/:feed_category_id/offers' do
    let(:path) { ->(params) { feed_category_offers_path(params.merge(feed_category_id: feed_category.id)) } }

    it_behaves_like 'multi'
  end

  describe 'GET /offers?favorite_id=:id' do
    let(:favorite) { create(:favorite, kind: :offers) }
    let(:path) { ->(params) { offers_path(params.merge(favorite_id: favorite.id)) } }

    before do
      # NOTE: we can create favorites_item only if offer is available but we can't move
      # this line to shared examples because other tests don't need them
      create(:favorites_item, favorite: favorite, kind: :_id, ext_id: offer['_id']) if defined?(offer)
      sign_in(favorite.user)
    end

    it_behaves_like 'multi'
  end
end