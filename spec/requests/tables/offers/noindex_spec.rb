# frozen_string_literal: true

require 'rails_helper'

describe Tables::OffersController, type: :request do
  let!(:feed_category) { create(:feed_category) }
  let!(:feed) { feed_category.feed }
  let!(:advertiser) { feed.advertiser }

  shared_examples 'multi' do
    context 'when request does not include any unwanted query string parameter' do
      let(:params) { {} }

      it_behaves_like 'not_to_includes_noindex'
    end

    context 'when request includes :page parameter' do
      let(:params) { { page: 2 } }

      it_behaves_like 'not_to_includes_noindex'
    end

    context 'when request includes :q parameter' do
      let(:params) { { q: 'q' } }

      it_behaves_like 'includes_robots_noindex'
    end

    context 'when request includes :per parameter' do
      let(:params) { { per: 2 } }

      it_behaves_like 'includes_robots_noindex'
    end

    context 'when request includes :sort parameter' do
      let(:params) { { sort: :asc } }

      it_behaves_like 'includes_robots_noindex'
    end

    context 'when request includes :order parameter' do
      let(:params) { { order: :id } }

      it_behaves_like 'includes_robots_noindex'
    end

    context 'when request includes :favorite_id parameter' do
      let(:params) { { favorite_id: 2 } }

      it_behaves_like 'includes_robots_noindex'
    end

    xcontext 'when request includes :filters parameter' do
      let(:params) { { filters: {} } }

      it_behaves_like 'includes_robots_noindex'
    end

    xcontext 'when request includes :columns parameter' do
      let(:params) { { columns: [] } }

      it_behaves_like 'includes_robots_noindex'
    end
  end

  describe 'GET /offers' do
    let(:path) { [:offers_path, { params: {} }] }

    it_behaves_like 'multi'
  end

  describe 'GET /advertisers/:advertiser_id/offers' do
    let(:path) { [:advertiser_offers_path, { params: { advertiser_id: advertiser.id } }] }

    it_behaves_like 'multi'
  end

  describe 'GET /feeds/:feed_id/offers' do
    let(:path) { [:feed_offers_path, { params: { feed_id: feed.id } }] }

    it_behaves_like 'multi'
  end

  describe 'GET /feed_categories/:feed_category_id/offers' do
    let(:path) { [:feed_category_offers_path, { params: { feed_category_id: feed_category.id } }] }

    it_behaves_like 'multi'
  end
end
