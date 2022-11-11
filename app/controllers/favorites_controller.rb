# frozen_string_literal: true

class FavoritesController < ApplicationController
  layout 'backoffice'
  include Paginatable
  before_action :set_favorite, only: %i[show edit update destroy]

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
