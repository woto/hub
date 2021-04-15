# frozen_string_literal: true

require 'rails_helper'

describe FavoritesController, type: :request do
  describe '#navbar_favorite_list' do
    subject { get navbar_favorite_list_favorites_path, xhr: true }

    context 'when user is authenticated' do
      let(:user) { create(:user) }

      it 'returns success response' do
        sign_in(user)
        subject
        expect(@response.parsed_body).to eq([])
      end
    end

    context 'when user is not authenticated' do
      it 'returns error' do
        subject
        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to eq('You need to sign in or sign up before continuing.')
      end
    end

    context 'when user 1 is the owner of the favorite list' do
      let(:favorite) { create(:favorite, kind: :accounts) }
      let(:user) { create(:user) }

      it 'shows favorite list to him' do
        sign_in(favorite.user)
        subject
        expect(@response.parsed_body).to(
          eq(['href' => "/en/accounts?favorite_id=#{favorite.id}", 'title' => favorite.name])
        )
      end

      it 'does not show favorites list to another user' do
        sign_in(user)
        subject
        expect(@response.parsed_body).to eq([])
      end
    end
  end
end
