# frozen_string_literal: true

class PostCategoriesController < ApplicationController
  layout 'backoffice'
  before_action :set_post_category, only: %i[show edit update destroy]
  skip_before_action :authenticate_user!

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
