# frozen_string_literal: true

require 'rails_helper'

describe FavoritesController, type: :request do
  describe 'GET /favorites/dropdown_list' do
    context 'when user is not authenticated' do
      it 'returns error' do
        get dropdown_list_favorites_path, xhr: true
        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to eq('You need to sign in or sign up before continuing.')
      end
    end

    context 'when favorite includes two favorites_items with kind `feeds` and one of them is passed in `ext_id`' do
      let(:user) { create(:user) }
      let!(:favorites_item) do
        create(:favorites_item, kind: :feeds, ext_id: 'a1', favorite: create(:favorite, kind: :feeds, user: user))
      end
      let!(:not_checked) do
        create(:favorites_item, kind: :feeds, ext_id: 'a2', favorite: create(:favorite, kind: :feeds, user: user))
      end
      let!(:empty_favorite) { create(:favorite, kind: :feeds, user: user) }

      before do
        # another `user`
        create(:favorites_item, kind: :feeds, ext_id: 'a2', favorite: create(:favorite, kind: :feeds))
        # another `favorite.kind` and `favorites_item.kind`
        create(:favorites_item, kind: :users, ext_id: Faker::Alphanumeric.alphanumeric,
                                favorite: create(:favorite, kind: :users, user: user))
      end

      it 'returns correct response' do
        sign_in(user)
        get dropdown_list_favorites_path(ext_id: 'a1', favorites_items_kind: :feeds), xhr: true
        expect(response.parsed_body).to(
          contain_exactly(
            {
              'count' => 1,
              'id' => favorites_item.favorite.id,
              'is_checked' => true,
              'name' => favorites_item.favorite.name
            },
            {
              'count' => 1,
              'id' => not_checked.favorite.id,
              'is_checked' => false,
              'name' => not_checked.favorite.name
            },
            {
              'count' => 0,
              'id' => empty_favorite.id,
              'is_checked' => false,
              'name' => empty_favorite.name
            }
          )
        )
      end
    end

    # rubocop:disable RSpec/NestedGroups
    # rubocop:disable RSpec/MultipleMemoizedHelpers
    describe 'special case with `favorites.kind == :offers`' do
      subject do
        sign_in(user)
        get dropdown_list_favorites_path(ext_id: 'a1', favorites_items_kind: favorites_items_kind), xhr: true
      end

      let(:user) { create(:user) }
      let(:favorite) { create(:favorite, kind: :offers, user: user) }

      before do
        create(:favorites_item, ext_id: 'a1', favorite: favorite, kind: :advertiser_id)
        create(:favorites_item, ext_id: 'a1', favorite: favorite, kind: :feed_id)
        create(:favorites_item, ext_id: 'a1', favorite: favorite, kind: :feed_category_id)
        create(:favorites_item, ext_id: 'a1', favorite: favorite, kind: :_id)
      end

      shared_examples_for 'includes 4 favorites_items' do
        it 'responses correctly' do
          subject
          expect(response.parsed_body).to eq([{ 'count' => 4, 'id' => favorite.id,
                                                'is_checked' => true, 'name' => favorite.name }])
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
    # rubocop:enable RSpec/MultipleMemoizedHelpers
    # rubocop:enable RSpec/NestedGroups
  end

  describe 'GET /favorites/navbar_favorite_list' do
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

  describe 'POST /favorites' do
    context 'when user is not authenticated' do
      it 'returns error' do
        post favorites_path, xhr: true
        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to eq('You need to sign in or sign up before continuing.')
      end
    end

    it 'returns error if favorite params are invalid' do
      user = create(:user)
      sign_in(user)

      post favorites_path, xhr: true
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.parsed_body).to eq(["Name can't be blank", "Kind can't be blank"])
    end

    context 'when favorites is not exists yet' do
      it 'creates favorites and add new favorites_item to it' do
        user = create(:user)
        sign_in(user)
        params = { name: 'name', ext_id: 'a1', favorites_items_kind: 'feeds', is_checked: true }
        action1 = -> { post favorites_path, params: params, xhr: true }
        check1 = -> { Favorite.where(name: 'name', kind: 'feeds', user_id: user.id).exists? }
        action2 = -> { expect(&action1).to change(&check1).from(false).to(true) }
        check2 = -> { FavoritesItem.where(ext_id: 'a1', kind: 'feeds', favorite: Favorite.last).exists? }
        expect(&action2).to change(&check2).from(false).to(true)
      end
    end

    context 'when favorites already exists' do
      it 'finds it and adds favorites_item to it' do
        user = create(:user)
        sign_in(user)
        create(:favorite, user: user, name: 'name', kind: 'feeds')

        params = { name: 'name', ext_id: 'a1', favorites_items_kind: 'feeds', is_checked: true }
        action1 = -> { post favorites_path, params: params, xhr: true }
        check1 = -> { Favorite.count }
        action2 = -> { expect(&action1).not_to change(&check1) }
        check2 = -> { FavoritesItem.where(ext_id: 'a1', kind: 'feeds', favorite: Favorite.last).exists? }
        expect(&action2).to change(&check2).from(false).to(true)
      end
    end

    context 'with `is_checked` as false' do
      it 'destroys favorites_item' do
        favorites_item = create(:favorites_item)
        ext_id = favorites_item.ext_id
        kind = favorites_item.kind
        favorite = favorites_item.favorite
        sign_in(favorite.user)

        params = { name: favorites_item.favorite.name,
                   ext_id: favorites_item.ext_id,
                   favorites_items_kind: favorites_item.kind,
                   is_checked: false }
        action1 = -> { post favorites_path, params: params, xhr: true }
        check1 = -> { Favorite.count }
        action2 = -> { expect(&action1).not_to change(&check1) }
        check2 = -> { FavoritesItem.where(ext_id: ext_id, kind: kind, favorite: favorite).exists? }
        expect(&action2).to change(&check2).from(true).to(false)
      end
    end

    context 'when favorites_item already exists and passed `is_checked` as true' do
      it 'does nothing' do
        favorites_item = create(:favorites_item)
        favorite = favorites_item.favorite
        sign_in(favorite.user)

        params = { name: favorites_item.favorite.name,
                   ext_id: favorites_item.ext_id,
                   favorites_items_kind: favorites_item.kind,
                   is_checked: true }
        action1 = -> { post favorites_path, params: params, xhr: true }
        check1 = -> { Favorite.count }
        action2 = -> { expect(&action1).not_to change(&check1) }
        check2 = -> { FavoritesItem.count }
        expect(&action2).not_to change(&check2)
      end
    end

    context 'when favorites_item does not exist but passed `is_checked` as false' do
      it 'does nothing' do
        user = create(:user)
        sign_in(user)
        create(:favorite, user: user, name: 'name', kind: 'feeds')

        params = { name: 'name', ext_id: 'a1', favorites_items_kind: 'feeds', is_checked: false }
        action1 = -> { post favorites_path, params: params, xhr: true }
        check1 = -> { Favorite.count }
        action2 = -> { expect(&action1).not_to change(&check1) }
        check2 = -> { FavoritesItem.count }
        expect(&action2).not_to change(&check2)
      end
    end
  end
end
