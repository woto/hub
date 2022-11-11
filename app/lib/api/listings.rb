# frozen_string_literal: true

module API
  class Listings < ::Grape::API
    prefix :api
    # auth :api_key

    resources :listings do
      desc 'Returns popular and own listings for sidebar' do
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

        @favorites
      end

      desc 'TODO' do
        # security [{ api_key: [] }]
      end

      params do
        requires :ext_id, type: String
        requires :name, type: String
        requires :description, type: String
        requires :is_public, type: Boolean
        requires :is_checked, type: Boolean
      end

      post do
        favorite = if params[:id]
                     FavoritePolicy::Scope.new(current_user, Favorite).resolve.find(params[:id])
                   else
                     Favorite.new(user: current_user)
                   end

        unless favorite.update(
          name: params[:name],
          description: params[:description],
          is_public: params[:is_public],
          kind: 'entities'
        )
          return { json: favorite.errors.full_messages, status: :unprocessable_entity }
        end

        is_create = ActiveModel::Type::Boolean.new.cast(params[:is_checked])
        result = if is_create
                   favorites_item = favorite.favorites_items.find_or_initialize_by(
                     ext_id: params[:ext_id],
                     kind: 'entities'
                   )
                   favorites_item.save!
                   # TODO: check AR status
                   body = ApplicationController.helpers.t('successfully_added', favorite_name: favorite.name)
                 else
                   favorite.favorites_items.destroy_by(
                     ext_id: params[:ext_id],
                     kind: 'entities'
                   )
                   # TODO: check AR status
                   body = ApplicationController.helpers.t('successfully_removed', favorite_name: favorite.name)
                 end

        if result
          return {json: { body: }}
        else
          head :unprocessable_entity
        end
      end
    end
  end
end
