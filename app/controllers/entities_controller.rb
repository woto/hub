# frozen_string_literal: true

class EntitiesController < ApplicationController
  layout 'roastme/pages'

  before_action :set_entity, only: %i[show]
  skip_before_action :authenticate_user!, only: [:show]

  # GET /entities/:id
  def show
    seo.langs! { |l| entity_url(@entity, locale: l) }
    seo.canonical! entity_url(@entity)

    # @draft = ::Mentions::IndexInteractor.call(
    #   current_user:,
    #   params: { entity_ids: [params[:id]] }
    # ).object
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_entity
    @entity = Entity.find(params[:id])
  end
end
