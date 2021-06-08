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

  # GET /posts/1/edit
  def edit; end

  # POST /posts
  def create
    GlobalHelper.retryable do
      @post = policy_scope(Post).new(post_params)
      authorize(@post)
      if @post.save
        redirect_to @post, notice: 'Post was successfully created.'
      else
        render :new
      end
    end
  end

  # PATCH/PUT /posts/1
  def update
    GlobalHelper.retryable do
      authorize(@post)
      if @post.update(post_params)
        redirect_to @post, notice: 'Post was successfully updated.'
      else
        render :edit
      end
    end
  end

  # DELETE /posts/1
  def destroy
    @post.destroy
    redirect_to posts_url, notice: 'Post was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = policy_scope(Post).find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def post_params
    params.require(:post).permit(:title, :status, :intro, :body, :language, :post_category_id, :comment,
                                 :published_at, :realm_id, tags: [], extra_options: {})
  end
end
