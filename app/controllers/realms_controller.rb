# frozen_string_literal: true

class RealmsController < ApplicationController
  layout 'backoffice'
  before_action :set_realm, only: %i[show edit update destroy]

  # GET /realms/new
  def new
    @realm = Realm.new
    authorize(@realm)
  end

  # GET /realms/:id/edit
  def edit
    authorize(@realm)
  end

  # POST /realms
  def create
    @realm = policy_scope(Realm).new(realm_params)
    authorize(@realm)
    if @realm.save
      redirect_to @realm, notice: t('.realm_was_successfully_created')
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /realms/:id
  def update
    authorize(@realm)
    if @realm.update(realm_params)
      redirect_to @realm, notice: t('.realm_was_successfully_updated')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # GET /realms/:id
  def show
    authorize(@realm)
  end

  # DELETE /realms/:id
  def destroy
    authorize(@realm)

    respond_to do |format|
      if @realm.destroy
        format.html do
          redirect_back fallback_location: realms_url, notice: t('.realm_was_successfully_destroyed')
        end
      else
        format.html do
          # TODO: Bullshit. If I add `status: :unprocessable_entity` then redirect doesn't work
          redirect_back fallback_location: realms_url, alert: @realm.errors.full_messages.join
        end
      end
    end
  end

  private

  def set_realm
    @realm = Realm.find(params[:id])
  end

  def realm_params
    params.require(:realm).permit(:title, :domain, :locale, :kind, :after_head_open, :before_head_close, :after_body_open, :before_body_close)
  end
end
