# frozen_string_literal: true

class FavoritesController < ApplicationController
  layout 'backoffice'
  include Paginatable
  before_action :set_favorite, only: %i[show edit update destroy]

  # GET /favorites/navbar_favorite_list
  def navbar_favorite_list
    @navbar_favorite_items = policy_scope(Favorite).order(updated_at: :desc).limit(10)

    respond_to do |format|
      format.json { @navbar_favorite_items }
    end
  end

  # GET /favorites/dropdown_list
  def dropdown_list
    # TODO: make it a little bit nicer with dry contract
    raise '`ext_id` must be present' if params[:ext_id].blank?
    raise '`favorites_items_kind` must be present' if params[:favorites_items_kind].blank?

    ext_id = ActiveRecord::Base.connection.quote(params[:ext_id])
    favorites_items_kind = FavoritesItem.kinds[params[:favorites_items_kind]]

    select = <<-SQL
      favorites.id,
      name,
      -- previous version was like like below. With dynamic count
      -- COUNT(favorites_items.id) as count
      favorites_items_count as count,
      COUNT(
        CASE WHEN favorites_items.ext_id = #{ext_id} AND favorites_items.kind = #{favorites_items_kind}
             THEN 1
             ELSE NULL
        END
      ) as "is_checked"
    SQL

    @favorites = policy_scope(Favorite)
                 .select(select)
                 .where(kind: FavoritesItem.favorites_item_kind_to_favorite_kind(params[:favorites_items_kind]))
                 .left_joins(:favorites_items)
                 .group(:id, :name)
                 .order(:name)

    respond_to do |format|
      format.json { @favorites }
    end
  end

  # GET /favorites/update_star
  def update_star
    kind = params[:favorites_items_kind]
    ext_id = params[:ext_id]
    @exists = policy_scope(FavoritesItem)
    @exists = @exists.where(kind: kind, ext_id: ext_id).exists?

    respond_to do |format|
      format.json { @exists }
    end
  end

  # GET /favorites/1
  def show
    raise 'TODO'
  end

  # GET /favorites/1/edit
  def edit
    raise 'TODO'
  end

  # POST /favorites
  def create
    favorite = policy_scope(Favorite).find_or_create_by(
      name: params[:name],
      kind: FavoritesItem.favorites_item_kind_to_favorite_kind(params[:favorites_items_kind])
    )

    if favorite.invalid?
      respond_to do |format|
        format.json { render(json: favorite.errors.full_messages, status: :unprocessable_entity) and return }
      end
    end

    is_create = ActiveModel::Type::Boolean.new.cast(params[:is_checked])
    result = if is_create
               favorites_item = favorite.favorites_items.find_or_initialize_by(
                 ext_id: params[:ext_id],
                 kind: params[:favorites_items_kind]
               )
               favorites_item.save!
               # TODO: check AR status
               body = t('.successfully_added', favorite_name: favorite.name)
             else
               favorite.favorites_items.destroy_by(
                 ext_id: params[:ext_id],
                 kind: params[:favorites_items_kind]
               )
               # TODO: check AR status
               body = t('.successfully_removed', favorite_name: favorite.name)
             end

    if result
      render json: { body: body }
    else
      head :unprocessable_entity
    end
  end

  # PATCH/PUT /favorites/1
  def update
    raise 'TODO'
    if @favorite.update(
      name: params[:favorite][:name]
    )
      redirect_to @favorite, notice: 'Favorite was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /favorites/1
  def destroy
    if @favorite.destroy
      redirect_back(fallback_location: root_path, notice: t('.favorite_was_successfully_destroyed'))
    else
      redirect_back(fallback_location: root_path, alert: @entity.errors.full_messages.join)
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_favorite
    @favorite = policy_scope(Favorite).find(params[:id])
    authorize(@favorite)
  end
end
