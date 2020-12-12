# frozen_string_literal: true

class FavoritesController < ApplicationController
  layout 'backoffice'
  include Paginatable
  before_action :set_favorite, only: %i[show edit update destroy]

  def modal_select
    @favorites = policy_scope(Favorite).order(:is_default).to_a
    @favorites.prepend(Favorite.new(name: all_favorite_name))

    respond_to do |format|
      format.json { @favorites }
    end
  end

  def dropdown_list
    ext_id = ActiveRecord::Base.connection.quote(params['ext_id'])
    select = <<-SQL
      favorites.id, 
      name,
      COUNT(favorites_items.id) as count,
      COUNT(CASE WHEN favorites_items.ext_id = #{ext_id} then 1 ELSE NULL END) as "is_checked"
    SQL

    @favorites = policy_scope(Favorite)
                 .select(select)
                 .where(kind: params[:kind]).left_joins(:favorites_items)
                 .group(:id, :name)
                 .order(:name)

    respond_to do |format|
      format.json { @favorites }
    end
  end

  def modal_items
    @favorites_items = policy_scope(FavoritesItem)
                       .where(favorites: { kind: 'offers' })
                       .joins(:favorite)
                       .preload(:favorite)
                       .order(updated_at: :desc)
                       .page(@pagination_rule.page)
                       .per(@pagination_rule.per)

    if params[:favorite_name] && params[:favorite_name] != all_favorite_name
      @favorites_items.where!(favorites: { name: params[:favorite_name] })
    end

    respond_to do |format|
      format.json { @favorites_items }
    end
  end

  def update_star
    kind = favorite_params[:kind]
    ext_id = favorites_item_params[:ext_id]
    @exists = policy_scope(FavoritesItem)
    @exists = @exists.where(favorites: { kind: kind }, ext_id: ext_id).exists?

    respond_to do |format|
      format.json { @exists }
    end
  end

  # GET /favorites/1
  def show
    p 1
  end

  # GET /favorites/1/edit
  def edit
    p 1
  end

  # POST /favorites
  def create
    result = nil
    ActiveRecord::Base.transaction do
      favorite = policy_scope(Favorite).find_or_create_by(favorite_params)
      if favorite.invalid?
        render json: favorite.errors.full_messages, status: :unprocessable_entity
        return
      end

      result = if ActiveModel::Type::Boolean.new.cast(favorites_item_params[:is_checked])
                 favorites_item = favorite.favorites_items.find_or_initialize_by(favorites_item_params.slice(:ext_id))
                 favorites_item.data = get_offer if favorite.offers?
                 favorites_item.save!
               else
                 favorite.favorites_items.destroy_by(favorites_item_params.slice(:ext_id))
               end

      favorite.touch
    end

    if result
      head :ok
    else
      head :unprocessable_entity
    end
  end

  def write_post
    favorite = policy_scope(Favorite).find_or_create_by!(is_default: true, kind: 'offers') do |f|
      f.name = t('default')
    end
    favorites_item = favorite.favorites_items.find_or_initialize_by(favorites_item_params.slice(:ext_id))
    favorites_item.assign_attributes(data: get_offer, updated_at: Time.current)
    favorites_item.save!

    redirect_to new_post_path(embed: '1')
  end

  # PATCH/PUT /favorites/1
  def update
    if @favorite.update(favorite_params)
      redirect_to @favorite, notice: 'Favorite was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /favorites/1
  def destroy
    @favorite.destroy
    redirect_to favorites_url, notice: 'Favorite was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_favorite
    @favorite = Favorite.find(params[:id])
    authorize(@favorite)
  end

  # Only allow a trusted parameter "white list" through.
  def favorite_params
    params.permit(:name, :kind)
  end

  def favorites_item_params
    params.permit(:ext_id, :is_checked)
  end

  def get_offer
    @get_offer ||= GlobalHelper.get_offer(params[:ext_id])
  end

  # TODO: move to model
  def all_favorite_name
    t('all')
  end
end
