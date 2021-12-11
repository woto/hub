# frozen_string_literal: true

class MentionsController < ApplicationController
  layout 'backoffice'
  before_action :set_mention, only: %i[show edit update destroy]
  skip_before_action :authenticate_user!, only: [:show]

  # GET /mention/:id
  def show
    authorize(@mention)
  end

  # GET /mentions/new
  def new
    @mention = current_user.mentions.new(topics: [Topic.new])
    authorize(@mention)
  end

  # GET /mentions/:id/edit
  def edit
    authorize(@mention)
  end

  # POST /mentions
  def create
    @mention = policy_scope(Mention).new(permitted_attributes(Mention))
    authorize(@mention)

    # TODO: https://github.com/rails/rails/issues/43775
    result = false
    GlobalHelper.retryable do
      result = @mention.save
      raise ActiveRecord::RecordInvalid unless result
    rescue ActiveRecord::RecordInvalid
      raise ActiveRecord::Rollback
    end

    if result
      redirect_to @mention, notice: t('.mention_was_successfully_created')
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /mentions/:id
  def update
    authorize(@mention)

    # TODO: https://github.com/rails/rails/issues/43775
    result = false
    GlobalHelper.retryable do
      result = @mention.update(permitted_attributes(Mention))
      raise ActiveRecord::RecordInvalid unless result
    rescue ActiveRecord::RecordInvalid
      raise ActiveRecord::Rollback
    end

    if result
      redirect_to @mention, notice: t('.mention_was_successfully_updated')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /mentions/:id
  def destroy
    # TODO: https://github.com/rails/rails/issues/43775
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
