# frozen_string_literal: true

class EntitiesController < ApplicationController
  layout 'roastme/pages'

  include Paginatable

  before_action :set_entity, only: %i[show]
  # around_action :use_logidze_responsible, only: %i[create update]
  skip_before_action :authenticate_user!, only: [:show]

  # GET /entities/:id
  def show
    seo.langs! { |l| entity_url(@entity, locale: l) }
    seo.canonical! entity_url(@entity)
    authorize(@entity)

    @favorites_store = FavoritesStore.new(current_user)
    @favorites_store.append(@entity.id, 'entities')
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_entity
    @entity = policy_scope(Entity).with_log_data.find(params[:id])
  end

  # def use_logidze_responsible(&block)
  #   Logidze.with_responsible(Current.responsible.id, transactional: false, &block)
  # end
end
