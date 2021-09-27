# frozen_string_literal: true

class PostCategoriesController < ApplicationController
  layout 'backoffice'
  before_action :set_post_category, only: %i[show edit update destroy]

  # GET /post_categories/new
  def new
    @post_category = PostCategory.new
    authorize(@post_category)
  end

  # GET /post_categories/:id/edit
  def edit
    authorize(@post_category)
  end

  # POST /post_categories
  def create
    @post_category = policy_scope(PostCategory).new(post_category_params)
    authorize(@post_category)
    if @post_category.save
      redirect_to @post_category, notice: t('.post_category_was_successfully_created')
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /post_categories/:id
  def update
    authorize(@post_category)
    if @post_category.update(post_category_params)
      redirect_to @post_category, notice: t('.post_category_was_successfully_updated')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # GET /post_categories/:id
  def show
    authorize(@post_category)
  end

  # DELETE /post_categories/:id
  def destroy
    authorize(@post_category)

    respond_to do |format|
      if @post_category.destroy
        format.html do
          redirect_back fallback_location: post_categories_url, notice: t('.post_category_was_successfully_destroyed')
        end
      else
        format.html do
          # TODO: Bullshit. If I add `status: :unprocessable_entity` then redirect doesn't work
          redirect_back fallback_location: post_categories_url, alert: @post_category.errors.full_messages.join
        end
      end
    end
  end

  private

  def set_post_category
    @post_category = PostCategory.find(params[:id])
  end

  def post_category_params
    params.require(:post_category).permit(:title, :realm_id, :parent_id)
  end
end
