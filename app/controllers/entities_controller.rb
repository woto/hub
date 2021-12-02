# frozen_string_literal: true

class EntitiesController < ApplicationController
  layout 'backoffice'
  before_action :set_entity, only: %i[show edit update destroy]
  around_action :use_logidze_responsible, only: %i[create update]

  # GET /entities/:id
  def show
    authorize(@entity)
  end

  # GET /entities/new
  def new
    @entity = current_user.entities.new
    @url = url_for(@entity)
    authorize(@entity)
  end

  # GET /entities/:id/edit
  def edit
    @url = url_for(@entity)
    authorize(@entity)
  end

  # POST /entities
  def create
    GlobalHelper.retryable do
      @entity = current_user.entities.new(permitted_attributes(Entity))
      authorize(@entity)
      if @entity.save
        if params['commit'] == t('entities.form.submit_and_new')
          redirect_to new_entity_path, notice: t('.entity_was_successfully_created')
        else
          redirect_to @entity, notice: t('.entity_was_successfully_created')
        end
      else
        render :new, status: :unprocessable_entity
      end
    end
  end

  # PATCH/PUT /entities/:id
  def update
    GlobalHelper.retryable do
      authorize(@entity)
      if @entity.update(permitted_attributes(Entity))
        if params['commit'] == t('entities.form.submit_and_new')
          redirect_to new_entity_path, notice: t('.entity_was_successfully_updated')
        else
          redirect_to @entity, notice: t('.entity_was_successfully_updated')
        end
      else
        render :edit, status: :unprocessable_entity
      end
    end
  end

  # DELETE /entities/:id
  def destroy
    GlobalHelper.retryable do
      authorize(@entity)
      if @entity.destroy
        redirect_back fallback_location: entities_url, notice: t('.entity_was_successfully_destroyed')
      else
        redirect_back(fallback_location: entities_url, alert: @entity.errors.full_messages.join)
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_entity
    @entity = policy_scope(Entity).with_log_data.find(params[:id])
  end

  def use_logidze_responsible(&block)
    Logidze.with_responsible(Current.responsible.id, transactional: false, &block)
  end
end
