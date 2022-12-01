# frozen_string_literal: true

require 'rails_helper'
require_relative '../support/shrine_image'

describe API::Listings, type: :request, responsible: :admin do
  let!(:user) { create(:user) }

  describe 'DELETE /api/listings/:id' do
    let(:listing) { create(:favorite, name: 'name', kind: 'entities', user:) }

    before do
      create(:favorites_item, kind: 'entities', favorite: listing)
    end

    context 'when user deletes own listing' do
      it 'successfully deletes listing and children favorites_items' do
        sign_in(user)
        expect { delete "/api/listings/#{listing.id}" }.to(
          change(Favorite, :count).by(-1).and(
            change(FavoritesItem, :count).by(-1)
          )
        )
      end
    end

    context 'when user is not authenticated' do
      it 'returns error' do
        post "/api/listings/#{listing.id}", xhr: true
        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to eq('You need to sign in or sign up before continuing.')
      end
    end

    context 'when listing belongs to another user' do
      RSpec::Matchers.define_negated_matcher :not_change, :change

      it 'returns error' do
        another_user = create(:user)
        sign_in(another_user)

        expect { delete "/api/listings/#{listing.id}" }.to(
          not_change(Favorite, :count).and(
            not_change(FavoritesItem, :count)
          )
        )

        expect(response).to have_http_status(:not_found)
        expect(response.parsed_body).to eq(
          'error' => '<span class="translation_missing" title="translation missing: en.unable_to_find_listing">Unable To Find Listing</span>'
        )
      end
    end
  end

  describe 'PATCH /api/listings/:id' do
    let!(:listing) { create(:favorite, name: 'name', kind: 'entities', user:) }
    let(:params) { { name: 'new name' } }

    context 'when user is not authenticated' do
      it 'returns error' do
        patch "/api/listings/#{listing.id}", params: params, xhr: true
        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to eq('You need to sign in or sign up before continuing.')
      end
    end

    context 'when listing belongs to another user' do
      RSpec::Matchers.define_negated_matcher :not_change, :change

      it 'returns error' do
        another_user = create(:user)
        sign_in(another_user)

        expect { patch "/api/listings/#{listing.id}", params: }.to(
          not_change(Favorite, :count).and(
            not_change(FavoritesItem, :count)
          )
        )

        expect(response).to have_http_status(:not_found)
        expect(response.parsed_body).to eq(
          'error' => '<span class="translation_missing" title="translation missing: en.unable_to_find_listing">Unable To Find Listing</span>'
        )
      end
    end

    context 'when passed name' do
      it 'updates name' do
        sign_in(user)
        expect { patch "/api/listings/#{listing.id}", params:, xhr: true }.to(
          not_change(Favorite, :count).and(
            not_change(FavoritesItem, :count).and(
              change { listing.reload.name }.from('name').to('new name')
            )
          )
        )
      end
    end
  end

  describe 'POST /api/listings/add_item' do
    context 'when favorites already exists' do
      it 'finds it and adds favorites_item to it' do
        user = create(:user)
        sign_in(user)
        listing = create(:favorite, name: 'name', kind: 'entities', user:)

        params = { listing_id: listing.id, ext_id: 'a1' }
        action1 = -> { post '/api/listings/add_item', params: params, xhr: true }
        check1 = -> { Favorite.count }
        action2 = -> { expect(&action1).not_to change(&check1) }
        check2 = -> { FavoritesItem.where(ext_id: 'a1', kind: 'entities', favorite: Favorite.last).exists? }
        expect(&action2).to change(&check2).from(false).to(true)
      end
    end

    context 'when favorites_item already exists in listing' do
      it 'does nothing on attempt to add it again' do
        favorites_item = create(:favorites_item, kind: 'entities')
        listing = favorites_item.favorite
        sign_in(listing.user)

        params = { listing_id: listing.id, ext_id: favorites_item.ext_id }
        action1 = -> { post '/api/listings/', params: params, xhr: true }
        check1 = -> { Favorite.count }
        action2 = -> { expect(&action1).not_to change(&check1) }
        check2 = -> { FavoritesItem.count }
        expect(&action2).not_to change(&check2)
      end
    end
  end

  describe 'POST /api/listings/remove_item' do
    context 'with `is_checked` as false' do
      it 'destroys favorites_item' do
        favorites_item = create(:favorites_item, kind: 'entities')
        ext_id = favorites_item.ext_id
        kind = favorites_item.kind
        favorite = favorites_item.favorite
        sign_in(favorite.user)

        headers = { 'HTTP_API_KEY' => user.api_key }

        params = {
          listing_id: favorite.id,
          ext_id: favorites_item.ext_id
        }
        action1 = -> { post '/api/listings/remove_item', headers: headers, params: params }
        check1 = -> { Favorite.count }
        action2 = -> { expect(&action1).not_to change(&check1) }
        check2 = -> { FavoritesItem.where(ext_id:, kind:, favorite:).exists? }
        expect(&action2).to change(&check2).from(true).to(false)
      end
    end

    context 'when favorites_item does not exist in listing' do
      it 'does nothing' do
        user = create(:user)
        sign_in(user)
        listing = create(:favorite, user:, name: 'name', kind: 'entities')

        params = { listing_id: listing.id, ext_id: 'a1' }
        action1 = -> { post '/api/listings/remove_item', params: params, xhr: true }
        check1 = -> { Favorite.count }
        action2 = -> { expect(&action1).not_to change(&check1) }
        check2 = -> { FavoritesItem.count }
        expect(&action2).not_to change(&check2)
      end
    end
  end

  describe 'POST /api/listings' do
    context 'when user is not authenticated' do
      it 'returns error' do
        post '/api/listings', xhr: true
        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to eq('You need to sign in or sign up before continuing.')
      end
    end

    it 'returns error if favorite params are invalid' do
      user = create(:user)
      sign_in(user)

      post '/api/listings', xhr: true
      expect(response).to have_http_status(:bad_request)
      expect(response.parsed_body).to eq({
                                           'error' => 'ext_id is missing, name is missing, description is missing, is_public is missing'
                                         })
    end

    context 'when favorites is not exists yet' do
      it 'creates favorites and add new favorites_item to it' do
        user = create(:user)
        sign_in(user)
        params = { name: 'name', ext_id: 'a1', favorites_items_kind: 'entities',
                   is_checked: true, description: 'description', is_public: true }
        action1 = -> { post '/api/listings', params: params, xhr: true }
        check1 = -> { Favorite.where(name: 'name', kind: 'entities', user_id: user.id).exists? }
        action2 = -> { expect(&action1).to change(&check1).from(false).to(true) }
        check2 = -> { FavoritesItem.where(ext_id: 'a1', kind: 'entities', favorite: Favorite.last).exists? }
        expect(&action2).to change(&check2).from(false).to(true)
      end
    end
  end

  describe 'GET /api/listings' do
    context 'when user is not authenticated' do
      it 'returns successful response' do
        get '/api/listings',
            params: { ext_id: 1, favorites_items_kind: 'entities' }
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body).to eq([])
      end
    end

    context 'when required ext_id is not passed' do
      it 'returns error' do
        get '/api/listings',
            params: { favorites_items_kind: 'entities' }
        expect(response).to have_http_status(:bad_request)
        expect(response.parsed_body).to eq({ 'error' => 'ext_id is missing' })
      end
    end

    context 'when required favorites_items_kind is not passed' do
      it 'returns error' do
        get '/api/listings',
            params: { ext_id: 1 }
        expect(response).to have_http_status(:bad_request)
        expect(response.parsed_body).to eq('error' => 'favorites_items_kind is missing')
      end
    end

    context 'when search_string is present and there is favorite with same name' do
      context 'when favorite is public' do
        before do
          favorite = create(:favorite, name: 'a1', kind: :entities, is_public: true)
          create(:favorites_item, favorite:, kind: :entities)

          does_not_matched_name_favorite = create(:favorite, name: 'a2', kind: :entities, is_public: true)
          create(:favorites_item, favorite: does_not_matched_name_favorite, kind: :entities)

          another_user_favorite = create(:favorite, name: 'a1', kind: :entities, is_public: false)
          create(:favorites_item, favorite: another_user_favorite, kind: :entities)
        end

        it 'returns favorites' do
          get '/api/listings',
              params: { search_string: 'a1', ext_id: Faker::Lorem.word, favorites_items_kind: :entities }

          expect(response).to have_http_status(:ok)
          expect(response.parsed_body).to eq(
            [{
              'count' => 1,
              'id' => 1,
              'image' => nil,
              'is_checked' => 0,
              'is_owner' => false,
              'is_public' => true,
              'name' => 'a1',
              'description' => nil
            }]
          )
        end
      end

      context 'when favorite is owned by user' do
        before do
          favorite = create(:favorite, name: 'a1', user:, kind: :entities, is_public: false)
          create(:favorites_item, favorite:, kind: :entities)

          does_not_matched_name_favorite = create(:favorite, name: 'a2', kind: :entities, is_public: true)
          create(:favorites_item, favorite: does_not_matched_name_favorite, kind: :entities)

          another_user_favorite = create(:favorite, name: 'a1', kind: :entities, is_public: false)
          create(:favorites_item, favorite: another_user_favorite, kind: :entities)
        end

        it 'returns favorites' do
          sign_in(user)

          get '/api/listings',
              headers: { 'HTTP_API_KEY' => user.api_key },
              params: { search_string: 'a1', ext_id: Faker::Lorem.word, favorites_items_kind: :entities }

          expect(response).to have_http_status(:ok)
          expect(response.parsed_body).to eq(
            [{
              'count' => 1,
              'id' => 1,
              'image' => nil,
              'is_checked' => 0,
              'is_owner' => true,
              'is_public' => false,
              'name' => 'a1',
              'description' => nil
            }]
          )
        end
      end
    end

    context 'when search_string is present but there is no favorite with same name' do
      before do
        favorite = create(:favorite, name: 'a1', user:, kind: :entities, is_public: false)
        create(:favorites_item, favorite:, kind: :entities)

        does_not_matched_name_favorite = create(:favorite, name: 'a2', kind: :entities, is_public: true)
        create(:favorites_item, favorite: does_not_matched_name_favorite, kind: :entities)

        another_user_favorite = create(:favorite, name: 'a1', kind: :entities, is_public: false)
        create(:favorites_item, favorite: another_user_favorite, kind: :entities)
      end

      it 'does not show any private or public listings' do
        sign_in(user)

        get '/api/listings',
            headers: { 'HTTP_API_KEY' => user.api_key },
            params: { search_string: 'a3', ext_id: Faker::Lorem.word, favorites_items_kind: :entities }

        expect(response).to have_http_status(:ok)
        expect(response.parsed_body).to eq([])
      end
    end

    context 'when search_string is empty' do
      describe 'private favorites' do
        before do
          favorite = create(:favorite, name: 'a1', user:, kind: :entities, is_public: false)
          create(:favorites_item, favorite:, kind: :entities)

          does_not_matched_name_favorite = create(:favorite, name: 'a2', kind: :entities, is_public: true)
          create(:favorites_item, favorite: does_not_matched_name_favorite, kind: :entities)

          another_user_favorite = create(:favorite, name: 'a1', kind: :entities, is_public: false)
          create(:favorites_item, favorite: another_user_favorite, kind: :entities)
        end

        it "returns all user's private favorites" do
          sign_in(user)

          get '/api/listings',
              headers: { 'HTTP_API_KEY' => user.api_key },
              params: { search_string: '', ext_id: Faker::Lorem.word, favorites_items_kind: :entities }

          expect(response).to have_http_status(:ok)
          expect(response.parsed_body).to eq(
            [{
              'count' => 1,
              'id' => 1,
              'image' => nil,
              'is_checked' => 0,
              'is_owner' => true,
              'is_public' => false,
              'name' => 'a1',
              'description' => nil
            }]
          )
        end
      end

      describe 'public favorites' do
        before do
          favorite = create(:favorite, name: 'a1', kind: :entities, is_public: true)
          create(:favorites_item, favorite:, kind: :entities)

          does_not_matched_name_favorite = create(:favorite, name: 'a2', kind: :entities, is_public: true)
          create(:favorites_item, favorite: does_not_matched_name_favorite, kind: :entities)

          another_user_favorite = create(:favorite, name: 'a1', kind: :entities, is_public: false)
          create(:favorites_item, favorite: another_user_favorite, kind: :entities)
        end

        it 'returns public favorites which are includes entities with requested ext_id and kind' do
          get '/api/listings',
              params: { search_string: 'a1', ext_id: Faker::Lorem.word, favorites_items_kind: :entities }

          expect(response).to have_http_status(:ok)
          expect(response.parsed_body).to eq(
            [{
              'count' => 1,
              'id' => 1,
              'image' => nil,
              'is_checked' => 0,
              'is_owner' => false,
              'is_public' => true,
              'name' => 'a1',
              'description' => nil
            }]
          )
        end
      end
    end

    context 'when favorite includes two favorites_items with kind `entities` and one of them is passed in `ext_id`' do
      let!(:favorites_item) do
        create(:favorites_item, kind: 'entities', ext_id: 'a1', favorite: create(:favorite, kind: 'entities', user:))
      end
      let!(:not_checked) do
        create(:favorites_item, kind: 'entities', ext_id: 'a2', favorite: create(:favorite, kind: 'entities', user:))
      end
      let!(:empty_favorite) { create(:favorite, kind: 'entities', user:) }

      before do
        # another `user`
        create(:favorites_item, kind: 'entities', ext_id: 'a2', favorite: create(:favorite, kind: 'entities'))
        # another `favorite.kind` and `favorites_item.kind`
        create(:favorites_item, kind: :users, ext_id: Faker::Alphanumeric.alphanumeric,
                                favorite: create(:favorite, kind: :users, user:))
      end

      it 'returns correct response' do
        sign_in(user)

        get '/api/listings',
            headers: { 'HTTP_API_KEY' => user.api_key },
            params: { ext_id: 'a1', favorites_items_kind: 'entities' }

        expect(response.parsed_body).to(
          contain_exactly(
            {
              'count' => 1,
              'id' => favorites_item.favorite.id,
              'image' => nil,
              'is_checked' => 1,
              'is_public' => false,
              'is_owner' => true,
              'name' => favorites_item.favorite.name,
              'description' => nil
            },
            {
              'count' => 1,
              'id' => not_checked.favorite.id,
              'image' => nil,
              'is_checked' => 0,
              'is_public' => false,
              'is_owner' => true,
              'name' => not_checked.favorite.name,
              'description' => nil
            },
            {
              'count' => 0,
              'id' => empty_favorite.id,
              'image' => nil,
              'is_checked' => 0,
              'is_public' => false,
              'is_owner' => true,
              'name' => empty_favorite.name,
              'description' => nil
            }
          )
        )
      end
    end

    # rubocop:disable RSpec/NestedGroups
    describe 'special case with `favorites.kind == :offers`' do
      subject do
        sign_in(user)
        get '/api/listings',
            headers: { 'HTTP_API_KEY' => user.api_key },
            params: { ext_id: 'a1', favorites_items_kind: }
      end

      let(:favorite) { create(:favorite, kind: :offers, user:) }

      before do
        create(:favorites_item, ext_id: 'a1', favorite:, kind: :advertiser_id)
        create(:favorites_item, ext_id: 'a1', favorite:, kind: :feed_id)
        create(:favorites_item, ext_id: 'a1', favorite:, kind: :feed_category_id)
        create(:favorites_item, ext_id: 'a1', favorite:, kind: :_id)
      end

      shared_examples_for 'includes 4 favorites_items' do
        it 'responses correctly' do
          subject
          expect(response.parsed_body).to eq(
            [{
              'count' => 4,
              'id' => favorite.id,
              'image' => nil,
              'is_checked' => 1,
              'is_owner' => true,
              'is_public' => false,
              'name' => favorite.name,
              'description' => nil
            }]
          )
        end
      end

      context 'when `favorites_items_kind` is `:_id`' do
        let(:favorites_items_kind) { :_id }

        it_behaves_like 'includes 4 favorites_items'
      end

      context 'when `favorites_items_kind` is `:advertiser_id`' do
        let(:favorites_items_kind) { :advertiser_id }

        it_behaves_like 'includes 4 favorites_items'
      end

      context 'when `favorites_items_kind` is `:feed_id`' do
        let(:favorites_items_kind) { :feed_id }

        it_behaves_like 'includes 4 favorites_items'
      end

      context 'when `favorites_items_kind` is `:feed_category_id`' do
        let(:favorites_items_kind) { :feed_category_id }

        it_behaves_like 'includes 4 favorites_items'
      end
    end
    # rubocop:enable RSpec/NestedGroups
  end

  describe 'GET /api/listings/sidebar' do
    let!(:own_favorites_item) do
      create(:favorites_item, kind: :entities, favorite: create(:favorite, kind: :entities, user:))
    end

    let!(:public_favorites_item) do
      create(:favorites_item, kind: :entities, favorite: create(:favorite, kind: :entities, is_public: true))
    end

    before do
      # favorite with another kind
      create(:favorites_item, kind: :users, favorite: create(:favorite, kind: :users, is_public: true, user:))
      # private favorite of another user
      create(:favorites_item, kind: :entities, favorite: create(:favorite, kind: :entities))
    end

    it "returns user's private and at some public favorites" do
      sign_in(user)

      get '/api/listings/sidebar',
          headers: { 'HTTP_API_KEY' => user.api_key },
          params: { ext_id: 1, favorites_items_kind: 'entities' }

      expect(response).to have_http_status(:ok)

      expect(response.parsed_body).to contain_exactly(
        match(
          'favorites_items_count' => 1,
          'id' => own_favorites_item.favorite.id,
          'is_owner' => true,
          'is_public' => false,
          'kind' => 'entities',
          'name' => own_favorites_item.favorite.name,
          'created_at' => be_a(String),
          'updated_at' => be_a(String),
          'user_id' => own_favorites_item.favorite.user.id
        ),
        match(
          'favorites_items_count' => 1,
          'id' => public_favorites_item.favorite.id,
          'is_owner' => false,
          'is_public' => true,
          'kind' => 'entities',
          'name' => public_favorites_item.favorite.name,
          'created_at' => be_a(String),
          'updated_at' => be_a(String),
          'user_id' => public_favorites_item.favorite.user.id
        )
      )
    end
  end
end
