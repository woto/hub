# frozen_string_literal: true

module Mentions
  class EntitiesController < ApplicationController
    before_action :set_entity, only: %i[edit update card]
    before_action { @is_modal = true }

    def assign
      authorize(%i[mentions entity], :assign?)
      respond_to do |format|
        format.json
      end
    end

    def search
      authorize(%i[mentions entity], :search?)
      @entities = Interactors::Mentions::Entities.call(q: params[:q], page: params[:page] || 0, limit: 3).object

      respond_to do |format|
        format.json
        format.html
      end
    end

    def card
      authorize([:mentions, @entity])

      respond_to do |format|
        format.json
      end
    end

    def new
      @url = mentions_entities_path(form_id: params[:form_id])
      @entity = current_user.entities.new(title: params[:title], lookups: [Lookup.new])
      authorize([:mentions, @entity])
    end

    def create
      @url = mentions_entities_path(form_id: params[:form_id])
      # TODO: https://github.com/rails/rails/issues/43775
      # GlobalHelper.retryable do
      @entity = current_user.entities.new(permitted_attributes(Entity))
      authorize([:mentions, @entity])
      if @entity.save
        respond_to do |format|
          format.json { render 'mentions/entities/create_success' }
        end
      else
        respond_to do |format|
          format.json { render 'mentions/entities/create_failure', status: :unprocessable_entity }
        end
      end
      # end
    end

    # PATCH/PUT /entities/:id
    def update
      @url = mentions_entity_path(id: @entity, form_id: params[:form_id])
      # TODO: https://github.com/rails/rails/issues/43775
      # GlobalHelper.retryable do
      authorize([:mentions, @entity])
      if @entity.update(permitted_attributes(Entity))
        respond_to do |format|
          format.json { render 'mentions/entities/update_success' }
        end
      else
        respond_to do |format|
          format.json { render 'mentions/entities/update_failure', status: :unprocessable_entity }
        end
      end
      # end
    end

    def edit
      @url = mentions_entity_path(id: @entity, form_id: params[:form_id])
      authorize([:mentions, @entity])
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_entity
      @entity = policy_scope(Entity).with_log_data.find(params[:id])
    end
  end
end
