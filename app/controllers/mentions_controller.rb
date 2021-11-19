# frozen_string_literal: true

class MentionsController < ApplicationController
  layout 'backoffice'
  before_action :set_mention, only: %i[show edit update destroy]

  # GET /mention/:id
  def show
    authorize(@mention)
  end

  # GET /mentions/new
  def new
    @mention = current_user.mentions.new
    authorize(@mention)
  end

  # GET /mentions/:id/edit
  def edit
    authorize(@mention)
  end

  # POST /mentions
  def create
    GlobalHelper.retryable do
      @mention = policy_scope(Mention).new(permitted_attributes(Mention))
      authorize(@mention)
      if @mention.save
        redirect_to @mention, notice: t('.mention_was_successfully_created')
      else
        render :new, status: :unprocessable_entity
      end
    end
  end

  # PATCH/PUT /mentions/:id
  def update
    GlobalHelper.retryable do
      authorize(@mention)
      if @mention.update(permitted_attributes(Mention))
        redirect_to @mention, notice: t('.mention_was_successfully_updated')
      else
        render :edit, status: :unprocessable_entity
      end
    end
  end

  # DELETE /mentions/:id
  def destroy
    GlobalHelper.retryable do
      authorize(@mention)
      if @mention.destroy
        redirect_back fallback_location: mentions_url, notice: t('.mention_was_successfully_destroyed')
      else
        redirect_back(fallback_location: mentions_url, alert: @mention.errors.full_messages.join)
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_mention
    @mention = policy_scope(Mention).find(params[:id])
  end
end
