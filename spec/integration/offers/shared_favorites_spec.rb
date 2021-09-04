# frozen_string_literal: true

require 'rails_helper'

describe Tables::OffersController, type: :system, responsible: :admin do
  describe 'GET /offers' do
    describe 'advertiser star' do
      let!(:favorites_item_kind) { :advertiser_id }
      let!(:favorite_kind) { :offers }
      let!(:feed_category) { create(:feed_category) }
      let!(:ext_id) { feed_category.feed.advertiser.id }
      let(:visit_path) { offers_path(locale: :ru) }

      before do
        OfferCreator.call(feed_category: feed_category)
      end

      it_behaves_like 'shared favorites removing favorites_item from exiting favorite'
      it_behaves_like 'shared favorites adding favorites_item to exiting favorite'
      it_behaves_like 'shared favorites creating adding favorites_item to new favorite'
    end

    describe 'offer star' do
      let!(:favorites_item_kind) { :_id }
      let!(:favorite_kind) { :offers }
      let!(:feed_category) { create(:feed_category) }
      let!(:ext_id) { OfferCreator.call(feed_category: feed_category).fetch('_id') }
      let(:visit_path) { offers_path(locale: :ru) }

      it_behaves_like 'shared favorites removing favorites_item from exiting favorite'
      it_behaves_like 'shared favorites adding favorites_item to exiting favorite'
      it_behaves_like 'shared favorites creating adding favorites_item to new favorite'
    end
  end

  describe 'GET /advertisers/:advertiser_id/offers' do
    describe 'advertiser star' do
      let!(:favorites_item_kind) { :advertiser_id }
      let!(:favorite_kind) { :offers }
      let!(:feed_category) { create(:feed_category) }
      let!(:ext_id) { feed_category.feed.advertiser.id }
      let(:visit_path) { advertiser_offers_path(advertiser_id: feed_category.feed.advertiser.id, locale: :ru) }

      before do
        OfferCreator.call(feed_category: feed_category)
      end

      it_behaves_like 'shared favorites removing favorites_item from exiting favorite'
      it_behaves_like 'shared favorites adding favorites_item to exiting favorite'
      it_behaves_like 'shared favorites creating adding favorites_item to new favorite'
    end

    describe 'feed star' do
      let!(:favorites_item_kind) { :feed_id }
      let!(:favorite_kind) { :offers }
      let!(:feed_category) { create(:feed_category) }
      let!(:ext_id) { feed_category.feed.id }
      let(:visit_path) { advertiser_offers_path(advertiser_id: feed_category.feed.advertiser.id, locale: :ru) }

      before do
        OfferCreator.call(feed_category: feed_category)
      end

      it_behaves_like 'shared favorites removing favorites_item from exiting favorite'
      it_behaves_like 'shared favorites adding favorites_item to exiting favorite'
      it_behaves_like 'shared favorites creating adding favorites_item to new favorite'
    end

    describe 'offer star' do
      let!(:favorites_item_kind) { :_id }
      let!(:favorite_kind) { :offers }
      let!(:feed_category) { create(:feed_category) }
      let!(:ext_id) { OfferCreator.call(feed_category: feed_category).fetch('_id') }
      let(:visit_path) { advertiser_offers_path(advertiser_id: feed_category.feed.advertiser.id, locale: :ru) }

      it_behaves_like 'shared favorites removing favorites_item from exiting favorite'
      it_behaves_like 'shared favorites adding favorites_item to exiting favorite'
      it_behaves_like 'shared favorites creating adding favorites_item to new favorite'
    end
  end

  describe 'GET /feeds/:feed_id/offers' do
    describe 'feed star' do
      let!(:favorites_item_kind) { :feed_id }
      let!(:favorite_kind) { :offers }
      let!(:feed_category) { create(:feed_category) }
      let!(:ext_id) { feed_category.feed.id }
      let(:visit_path) { feed_offers_path(feed_id: feed_category.feed.id, locale: :ru) }

      before do
        OfferCreator.call(feed_category: feed_category)
      end

      it_behaves_like 'shared favorites removing favorites_item from exiting favorite'
      it_behaves_like 'shared favorites adding favorites_item to exiting favorite'
      it_behaves_like 'shared favorites creating adding favorites_item to new favorite'
    end

    describe 'feed_category star' do
      let!(:favorites_item_kind) { :feed_category_id }
      let!(:favorite_kind) { :offers }
      let!(:feed_category) { create(:feed_category) }
      let!(:ext_id) { feed_category.id }
      let(:visit_path) { feed_offers_path(feed_id: feed_category.feed.id, locale: :ru) }

      before do
        OfferCreator.call(feed_category: feed_category)
      end

      it_behaves_like 'shared favorites removing favorites_item from exiting favorite'
      it_behaves_like 'shared favorites adding favorites_item to exiting favorite'
      it_behaves_like 'shared favorites creating adding favorites_item to new favorite'
    end

    describe 'offer star' do
      let!(:favorites_item_kind) { :_id }
      let!(:favorite_kind) { :offers }
      let!(:feed_category) { create(:feed_category) }
      let!(:ext_id) { OfferCreator.call(feed_category: feed_category).fetch('_id') }
      let(:visit_path) { feed_offers_path(feed_id: feed_category.feed.id, locale: :ru) }

      it_behaves_like 'shared favorites removing favorites_item from exiting favorite'
      it_behaves_like 'shared favorites adding favorites_item to exiting favorite'
      it_behaves_like 'shared favorites creating adding favorites_item to new favorite'
    end
  end

  describe 'GET /feed_categories/:feed_category_id/offers' do
    describe 'parent feed_category star' do
      let!(:favorites_item_kind) { :feed_category_id }
      let!(:favorite_kind) { :offers }
      let!(:feed_category) { create(:feed_category) }
      let!(:ext_id) { feed_category.id }
      let(:visit_path) { feed_category_offers_path(feed_category_id: feed_category.id, locale: :ru) }

      before do
        OfferCreator.call(feed_category: feed_category)
      end

      it_behaves_like 'shared favorites removing favorites_item from exiting favorite'
      it_behaves_like 'shared favorites adding favorites_item to exiting favorite'
      it_behaves_like 'shared favorites creating adding favorites_item to new favorite'
    end

    describe 'child feed_category star' do
      let!(:favorites_item_kind) { :feed_category_id }
      let!(:favorite_kind) { :offers }
      let!(:feed_category) do
        feed = create(:feed)
        create(:feed_category, feed: feed, parent: create(:feed_category, feed: feed))
      end
      let!(:ext_id) { feed_category.id }
      let(:visit_path) { feed_category_offers_path(feed_category_id: feed_category.id, locale: :ru) }

      before do
        OfferCreator.call(feed_category: feed_category)
      end

      it_behaves_like 'shared favorites removing favorites_item from exiting favorite'
      it_behaves_like 'shared favorites adding favorites_item to exiting favorite'
      it_behaves_like 'shared favorites creating adding favorites_item to new favorite'
    end

    describe 'offer star' do
      let!(:favorites_item_kind) { :_id }
      let!(:favorite_kind) { :offers }
      let!(:feed_category) { create(:feed_category) }
      let!(:ext_id) { OfferCreator.call(feed_category: feed_category).fetch('_id') }
      let(:visit_path) { feed_category_offers_path(feed_category_id: feed_category.id, locale: :ru) }

      it_behaves_like 'shared favorites removing favorites_item from exiting favorite'
      it_behaves_like 'shared favorites adding favorites_item to exiting favorite'
      it_behaves_like 'shared favorites creating adding favorites_item to new favorite'
    end
  end
end
