# frozen_string_literal: true

class PostsController < ApplicationController
  layout 'backoffice'
  before_action :set_post, only: %i[show edit update destroy]

  # GET /posts/:id
  def show
    authorize(@post)
  end

  # GET /posts/new
  def new
    @post = current_user.posts.new(exchange_rate: ExchangeRate.pick)
    authorize(@post)
  end

  # GET /posts/:id/edit
  def edit
    authorize(@post)
  end

  # POST /posts
  def create
    GlobalHelper.retryable do
      @post = policy_scope(Post).new(permitted_attributes(Post))
      authorize(@post)
      if @post.save
        redirect_to @post, notice: t('.post_was_successfully_created')
      else
        render :new, status: :unprocessable_entity
      end
    end
  end

  # PATCH/PUT /posts/:id
  def update
    GlobalHelper.retryable do
      authorize(@post)
      if @post.update(permitted_attributes(Post))
        redirect_to @post, notice: t('.post_was_successfully_updated')
      else
        render :edit, status: :unprocessable_entity
      end
    end
  end

  # DELETE /posts/:id
  def destroy
    GlobalHelper.retryable do
      authorize(@post)
      redirect_to posts_url, notice: t('.post_was_successfully_destroyed') if @post.update(status: :removed_post)
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = policy_scope(Post).find(params[:id])
  end
end
