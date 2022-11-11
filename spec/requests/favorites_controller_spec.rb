# frozen_string_literal: true

require 'rails_helper'

describe FavoritesController, type: :request do

  describe 'GET /favorites/update_star' do
    let!(:favorites_item) do
      create(:favorites_item, kind: :users, ext_id: 'a1', favorite: create(:favorite, kind: :users))
    end

    context 'when user is not authenticated' do
      it 'returns error' do
        get update_star_favorites_path, xhr: true
        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to eq('You need to sign in or sign up before continuing.')
      end
    end

    context 'when correct ext_id with correct kind in favorites' do
      specify do
        sign_in(favorites_item.favorite.user)
        get update_star_favorites_path(ext_id: 'a1', favorites_items_kind: 'users'), xhr: true
        expect(response.parsed_body).to eq({ 'is_favorite' => true })
      end
    end

    context 'when correct ext_id with correct kind but belongs to another user' do
      specify do
        sign_in(create(:user))
        get update_star_favorites_path(ext_id: 'a1', favorites_items_kind: 'users'), xhr: true
        expect(response.parsed_body).to eq({ 'is_favorite' => false })
      end
    end

    context 'when correct ext_id with another kind in favorites' do
      specify do
        sign_in(favorites_item.favorite.user)
        get update_star_favorites_path(ext_id: 'a1', favorites_items_kind: 'feeds'), xhr: true
        expect(response.parsed_body).to eq({ 'is_favorite' => false })
      end
    end

    context 'when another ext_id with correct kind in favorites' do
      specify do
        sign_in(favorites_item.favorite.user)
        get update_star_favorites_path(ext_id: 'a2', favorites_items_kind: 'users'), xhr: true
        expect(response.parsed_body).to eq({ 'is_favorite' => false })
      end
    end
  end
end
