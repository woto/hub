# frozen_string_literal: true

module API
  class Listings < ::Grape::API
    prefix :api

    resources :listings do
      desc 'Returns popular and owned listings for sidebar' do
      end

      params do
      end

      get :sidebar do
        scope = Favorite.where(kind: :entities)

        private = current_user ? scope.where(user: current_user) : []
        public = scope.where(is_public: true).order(favorites_items_count: :desc).limit(5)

        Set.new([private, public].flatten).map do |favorite|
          {
            id: favorite.id,
            user_id: favorite.user_id,
            name: favorite.name,
            kind: favorite.kind,
            favorites_items_count: favorite.favorites_items_count,
            created_at: favorite.created_at,
            updated_at: favorite.updated_at,
            is_public: favorite.is_public,
            is_owner: current_user.try(:id) == favorite.user_id
          }
        end
      end

      desc "Returns matched by search_string or ext_id user's or public listings" do
        # security [{ api_key: [] }]
      end

      params do
        requires :ext_id, type: String
        requires :favorites_items_kind, type: String
        optional :search_string, type: String
      end

      get do
        ext_id = ActiveRecord::Base.connection.quote(params[:ext_id])
        favorites_items_kind = FavoritesItem.kinds[params[:favorites_items_kind]]

        # TODO: remove case about current user if user is not authenticated. (when this code will be moved to separate interactor)

        select = <<-SQL
          favorites.id,
          name,
          description,
          -- previous version was like like below. With dynamic count
          -- COUNT(favorites_items.id) as count
          favorites_items_count as count,
          COUNT(
            CASE WHEN favorites_items.ext_id = #{ext_id} AND favorites_items.kind = #{favorites_items_kind}
                THEN true
                ELSE NULL
            END
          ) as "is_checked",
          is_public,
          CASE WHEN favorites.user_id = #{current_user.try(:id) || '-1'}
            THEN true
            ELSE false
          END as "is_owner"
        SQL

        @favorites = Favorite
                     .select(select)
                     .where(kind: FavoritesItem.favorites_item_kind_to_favorite_kind(params[:favorites_items_kind]))
                     .left_joins(:favorites_items)
                     .group(:id, :name)
                     .order(:name)

        if params[:search_string].present?
          @favorites = @favorites.where(favorites: { user: current_user })
                                 .or(@favorites.where({ is_public: true }))
          @favorites = @favorites.where('name LIKE ?', "%#{params[:search_string]}%")
        else
          @favorites = @favorites.where(favorites: { user: current_user })
                                 .or(@favorites.where("
                                  is_public = true AND
                                  favorites_items.ext_id = #{ext_id} AND
                                  favorites_items.kind = #{favorites_items_kind}"))
        end

        @favorites.map do |favorite|
          {
            id: favorite.id,
            name: favorite.name,
            description: favorite.description,
            count: favorite.count,
            image: GlobalHelper.image_hash([favorite.images_relation].compact, %w[100]).first&.then do |image|
              {
                id: image['id'],
                image_url: ImageUploader::IMAGE_TYPES.include?(image['mime_type']) ? image['images']['100'] : nil,
              }
            end,
            is_checked: favorite.is_checked,
            is_public: favorite.is_public,
            is_owner: favorite.is_owner,
          }
        end
      end

      auth :api_key

      desc 'Creates new listing, with included item' do
        # security [{ api_key: [] }]
      end

      params do
        requires :ext_id, type: String
        requires :name, type: String
        requires :description, type: String
        requires :is_public, type: Boolean
      end

      post do
        favorite = Favorite.create(user: current_user,
                                   name: params[:name],
                                   description: params[:description],
                                   is_public: params[:is_public],
                                   kind: 'entities')
        error!({ error: favorite.errors.full_messages }, :unprocessable_entity) unless favorite.persisted?
        favorites_item = favorite.favorites_items.create(
          ext_id: params[:ext_id],
          kind: 'entities'
        )

        if params.dig(:image, :data)
          favorite.images_relation&.destroy
          image = Image.create!(image: params[:image][:data], user: current_user)
          ImagesRelation.create!(image:, relation: favorite, user: current_user)
        end

        if favorites_item.persisted?
          result = ApplicationController.helpers.t('successfully_added', favorite_name: favorite.name)
          return { message: result } if result
        end

        head :unprocessable_entity
      end

      desc 'Removes item from listing'

      params do
        requires :listing_id, type: Integer
        requires :ext_id, type: String
      end

      post 'remove_item' do
        favorites_items = FavoritesItemPolicy::Scope.new(current_user, FavoritesItem).resolve.destroy_by(
          favorite_id: params[:listing_id],
          ext_id: params[:ext_id],
          kind: 'entities'
        )
        favorites_item = favorites_items.first
        if favorites_item&.destroyed?
          result = ApplicationController.helpers.t('successfully_removed', favorite_name: favorites_item.favorite.name)
          return { message: result } if result
        else
          result = ApplicationController.helpers.t('unable_to_remove_item')
          error!({ error: result }, :unprocessable_entity)
        end
      end

      desc 'Adds item to listing'

      params do
        requires :listing_id, type: Integer
        requires :ext_id, type: String
      end

      post 'add_item' do
        favorite = FavoritePolicy::Scope.new(current_user, Favorite).resolve.find(params[:listing_id])
        favorite.favorites_items << FavoritesItem.new(kind: 'entities', ext_id: params[:ext_id])
        result = ApplicationController.helpers.t('successfully_added')
        return { message: result } if result
      end

      desc 'Update listing'

      params do
        optional :name, type: String, documentation: { param_type: 'body' }
        optional :description, type: String
        optional :is_public, type: Boolean
      end

      patch ':id' do
        begin
          favorite = FavoritePolicy::Scope.new(current_user, Favorite).resolve.find(params[:id])
        rescue StandardError
          result = ApplicationController.helpers.t('unable_to_find_listing')
          error!({ error: result }, :not_found) if result
        end

        hsh = {}
        hsh[:name] = params[:name] if params.key?(:name)
        hsh[:description] = params[:description] if params.key?(:description)
        hsh[:is_public] = params[:is_public] if params.key?(:is_public)
        hsh[:kind] = 'entities'

        if params.dig(:image, :data)
          favorite.images_relation&.destroy
          image = Image.create!(image: params[:image][:data], user: current_user)
          ImagesRelation.create!(image:, relation: favorite, user: current_user)
        end

        result = favorite.update(hsh)

        error!({ error: favorite.errors.full_messages }, :unprocessable_entity) unless result

        result = ApplicationController.helpers.t('successfully_updated')
        return { message: result }
      end

      desc 'Deletes listing'

      params do
      end

      delete ':id' do
        favorite = nil

        begin
          favorite = FavoritePolicy::Scope.new(current_user, Favorite).resolve.find(params[:id])
        rescue StandardError
          result = ApplicationController.helpers.t('unable_to_find_listing')
          error!({ error: result }, :not_found) if result
        end

        favorite.destroy
      end

      desc 'Returns listing entities'

      params do
        requires :id, type: Integer, desc: 'Listing id'
      end

      get ':id/entities' do
        entity_ids = FavoritesItem.where(favorite_id: params[:id]).pluck(:ext_id)
        query = ListingEntitiesQuery.call(entity_ids:, from: 0, size: 100).object
        GlobalHelper.elastic_client.search(query)
      end

      desc 'Returns listing mentions'

      params do
      end

      get ':id/mentions' do
      end
    end
  end
end
