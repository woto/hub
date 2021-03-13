# frozen_string_literal: true

require 'rails_helper'

shared_examples 'favorite star in title' do
  context 'when starrable object is a favorite' do
    before do
      favorite = create(:favorite, user: user, kind: favorite_kind)
      create(:favorites_item, favorite: favorite, kind: favorites_item_kind, ext_id: starrable.id)
    end

    it 'calls favorites helpers with correct parameters' do
      expect(FavoritesStore).to(
        receive(:new).with(user, [starrable.id], favorite_kind, favorites_item_kind).and_call_original
      )
      expect(FavoriteComponent).to(
        receive(:new).with(is_favorite: true, ext_id: starrable.id, favorites_items_kind: favorites_item_kind)
                     .and_call_original
      )
      visit polymorphic_path([starrable, favorite_kind],
                             favorites_item_kind => starrable.id, locale: :ru)
    end
  end

  context 'when starrable object is NOT a favorite' do
    it 'calls favorites helpers with correct parameters' do
      expect(FavoritesStore).to(
        receive(:new).with(user, [starrable.id], favorite_kind, favorites_item_kind).and_call_original
      )
      expect(FavoriteComponent).to(
        receive(:new).with(is_favorite: false, ext_id: starrable.id, favorites_items_kind: favorites_item_kind)
                     .and_call_original
      )
      visit polymorphic_path([starrable, favorite_kind],
                             favorites_item_kind => starrable.id, locale: :ru)
    end
  end
end

describe Tables::OffersController, type: :system do
  let(:user) { create(:user) }

  before do
    login_as(user, scope: :user)
  end

  context "when visits advertiser's offers" do
    it_behaves_like 'favorite star in title' do
      let(:starrable) { create(:advertiser) }
      let(:favorite_kind) { :offers }
      let(:favorites_item_kind) { :advertiser_id }
    end
  end

  context "when visits feed's offers" do
    it_behaves_like 'favorite star in title' do
      let(:starrable) { create(:feed) }
      let(:favorite_kind) { :offers }
      let(:favorites_item_kind) { :feed_id }
    end
  end

  context "when visits feed_category's offers" do
    it_behaves_like 'favorite star in title' do
      let(:starrable) { create(:feed_category) }
      let(:favorite_kind) { :offers }
      let(:favorites_item_kind) { :feed_category_id }
    end
  end

  context 'when visits all offers' do
    it 'does not call favorites helpers' do
      expect(FavoritesStore).not_to receive(:new)
      expect(FavoriteComponent).not_to receive(:new)
      visit offers_path(locale: :ru)
      expect(page).to have_title('Все товары')
    end
  end

  context "when visits favorite's offers" do
    it 'does not call favorites helper' do
      favorite = create(:favorite, kind: :offers)
      login_as(favorite.user, scope: :user)
      expect(FavoritesStore).not_to receive(:new)
      expect(FavoriteComponent).not_to receive(:new)
      visit offers_path(favorite_id: favorite.id, locale: :ru)
      expect(page).to have_title("Избранное: #{favorite.to_label}")
    end
  end
end
