# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable RSpec/MultipleMemoizedHelpers
describe 'Offers breadcrumbs', type: :system do
  let!(:offer) { OfferCreator.call(feed_category: child_feed_category) }

  let(:parent_feed_category) { create(:feed_category, feed: feed) }
  let(:child_feed_category) { create(:feed_category, feed: feed, parent: parent_feed_category) }
  let(:feed) { create(:feed, advertiser: advertiser) }
  let(:advertiser) { create(:advertiser) }
  let(:name) { offer['name'].first[Import::Offers::Hashify::HASH_BANG_KEY] }

  shared_examples_for 'breadcrumbs.homepage' do |param|
    specify do
      active_class = param == :active ? 'active' : '!active'
      link = find_link(
        'Главная',
        href: root_path(locale: :ru)
      )
      link.ancestor(class: ['breadcrumb-item', active_class])
    end
  end

  shared_examples_for 'breadcrumbs.dashboard' do |param|
    specify do
      active_class = param == :active ? 'active' : '!active'
      link = find_link(
        'Личн. кабинет',
        href: dashboard_path(locale: :ru)
      )
      link.ancestor(class: ['breadcrumb-item', active_class])
    end
  end

  shared_examples_for 'breadcrumbs.offers' do |param|
    specify do
      active_class = param == :active ? 'active' : '!active'
      link = find_link(
        'Все товары',
        href: offers_path(per: 12, q: name, locale: :ru)
      )
      link.ancestor(class: ['breadcrumb-item', active_class])
    end
  end

  shared_examples_for 'breadcrumbs.advertiser' do |param|
    specify do
      active_class = param == :active ? 'active' : '!active'
      link = find_link(
        advertiser.to_label,
        href: advertiser_offers_path(advertiser_id: advertiser, per: 12, q: name, locale: :ru)
      )
      link.ancestor(class: ['breadcrumb-item', active_class])
    end
  end

  shared_examples_for 'breadcrumbs.feed' do |param|
    specify do
      active_class = param == :active ? 'active' : '!active'
      link = find_link(
        feed.to_label,
        href: feed_offers_path(feed_id: feed, per: 12, q: name, locale: :ru)
      )
      link.ancestor(class: ['breadcrumb-item', active_class])
    end
  end

  shared_examples_for 'breadcrumbs.parent_feed_category' do |param|
    specify do
      active_class = param == :active ? 'active' : '!active'
      link = find_link(
        parent_feed_category.to_label,
        href: feed_category_offers_path(feed_category_id: parent_feed_category, per: 12, q: name, locale: :ru)
      )
      link.ancestor(class: ['breadcrumb-item', active_class])
    end
  end

  shared_examples_for 'breadcrumbs.child_feed_category' do |param|
    specify do
      active_class = param == :active ? 'active' : '!active'
      link = find_link(
        child_feed_category.to_label,
        href: feed_category_offers_path(feed_category_id: child_feed_category, per: 12, q: name, locale: :ru)
      )
      link.ancestor(class: ['breadcrumb-item', active_class])
    end
  end

  describe 'GET /offers' do
    before do
      visit offers_path(q: name, locale: :ru)
    end

    it_behaves_like 'breadcrumbs.homepage'
    it_behaves_like 'breadcrumbs.dashboard'
    it_behaves_like 'breadcrumbs.offers', :active
  end

  describe 'GET /advertisers/:advertiser_id/offers' do
    before do
      visit advertiser_offers_path(advertiser_id: advertiser.id, q: name, locale: :ru)
    end

    it_behaves_like 'breadcrumbs.homepage'
    it_behaves_like 'breadcrumbs.dashboard'
    it_behaves_like 'breadcrumbs.offers'
    it_behaves_like 'breadcrumbs.advertiser', :active
  end

  describe 'GET /feeds/:feed_id/offers' do
    before do
      visit feed_offers_path(feed_id: feed, q: name, locale: :ru)
    end

    it_behaves_like 'breadcrumbs.homepage'
    it_behaves_like 'breadcrumbs.dashboard'
    it_behaves_like 'breadcrumbs.offers'
    it_behaves_like 'breadcrumbs.advertiser'
    it_behaves_like 'breadcrumbs.feed', :active
  end

  describe 'GET /feed_categories/:feed_category_id/offers [parent]' do
    before do
      visit feed_category_offers_path(feed_category_id: parent_feed_category.id, q: name, locale: :ru)
    end

    it_behaves_like 'breadcrumbs.homepage'
    it_behaves_like 'breadcrumbs.dashboard'
    it_behaves_like 'breadcrumbs.offers'
    it_behaves_like 'breadcrumbs.advertiser'
    it_behaves_like 'breadcrumbs.feed'
    it_behaves_like 'breadcrumbs.parent_feed_category', :active
  end

  describe 'GET /feed_categories/:feed_category_id/offers [child]' do
    before do
      visit feed_category_offers_path(feed_category_id: child_feed_category.id, q: name, locale: :ru)
    end

    it_behaves_like 'breadcrumbs.homepage'
    it_behaves_like 'breadcrumbs.dashboard'
    it_behaves_like 'breadcrumbs.offers'
    it_behaves_like 'breadcrumbs.advertiser'
    it_behaves_like 'breadcrumbs.feed'
    it_behaves_like 'breadcrumbs.parent_feed_category'
    it_behaves_like 'breadcrumbs.child_feed_category', :active
  end

  describe 'GET /offers?favorite_id=' do
    specify do
      favorite = create(:favorite, kind: :offers)
      create(:favorites_item, ext_id: offer['_id'], kind: :_id, favorite: favorite)

      login_as(favorite.user, scope: :user)
      visit offers_path(favorite_id: favorite.id, q: name, locale: :ru)

      link = find_link(
        favorite.to_label,
        href: offers_path(favorite_id: favorite.id, per: 12, q: name, locale: :ru)
      )
      link.ancestor(class: %w[breadcrumb-item active])
    end
  end
end
# rubocop:enable RSpec/MultipleMemoizedHelpers
