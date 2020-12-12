# frozen_string_literal: true

class PostCategoriesController < ApplicationController
  layout 'backoffice'
  before_action :set_post_category, only: %i[show edit update destroy]
  skip_before_action :authenticate_user!

  private

  def set_post_category
    @post_category = PostCategory.find(params[:id])
  end

  def post_category_params
    params.require(:post_category).permit(:title, :realm_id, :parent_id)
  end
end
