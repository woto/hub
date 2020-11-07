# frozen_string_literal: true

class FavoritesController < ApplicationController
  ALLOWED_PARAMS = [:q, :per, :page, :sort, :order, :cols]
  REQUIRED_PARAMS = [:per, :cols]

  include Workspaceable
  layout 'backoffice'
  before_action :set_favorite, only: %i[show edit update destroy]
  before_action { prepend_view_path Rails.root + 'app' + 'views/template' }
  before_action { prepend_view_path Rails.root + 'app' + 'views/table' }

  # GET /favorites
  def index

    favorites = Favorite.__elasticsearch__.search(
        params[:q].presence || '*',
        _source: Columns::FavoriteForm.parsed_columns_for(request),
        sort: "#{params[:sort]}:#{params[:order]}"
    ).page(@pagination_rule.page).per(@pagination_rule.per)

    @favorites = OfferDecorator.decorate_collection(favorites)

    render 'empty_page' and return if @favorites.empty?

    @columns_form = Columns::FavoriteForm.new(displayed_columns: Columns::FavoriteForm.parsed_columns_for(request))
    render 'index', locals: { rows: @favorites }
  end

  def select
    @favorites = policy_scope(Favorite).order(:is_default).to_a
    @favorites.prepend(Favorite.new(name: all_favorite_name))

    respond_to do |format|
      format.json { @favorites }
    end
  end

  def list
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

  def items
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

  def refresh
    kind = favorite_params[:kind]
    ext_id = favorites_item_params[:ext_id]
    @exists = policy_scope(FavoritesItem)
    @exists = @exists.where(favorites: { kind: kind }, ext_id: ext_id).exists?

    respond_to do |format|
      format.json { @exists }
    end
  end

  # GET /favorites/1
  def show; end

  # GET /favorites/new
  def new
    @favorite = Favorite.new
  end

  # GET /favorites/1/edit
  def edit; end

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

  def write
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

  def all_favorite_name
    t('all')
  end

  def set_pagination_rule
    @pagination_rule = PaginationRules.new(request, 6, 30, [2, 3, 4, 6, 8, 9, 10, 12, 21, 30, 33, 42])
  end

  def set_settings
    @settings = { singular: :favorite,
                  plural: :favorites,
                  model_class: Favorite,
                  form_class: Columns::FavoriteForm }
  end

  def system_default_workspace
    url_for(**workspace_params,
            cols: @settings[:form_class].default_stringified_columns_for(request),
            per: @pagination_rule.per,
            sort: :id,
            order: :desc)
  end
end
