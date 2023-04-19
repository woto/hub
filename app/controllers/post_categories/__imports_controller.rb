# frozen_string_literal: true

module PostCategories
  class ImportsController < ApplicationController
    layout 'backoffice'

    def new
      @post_categories_import = PostCategories::CreatePostCategoryImport.new
      authorize(@post_categories_import)
    end

    def create
      authorize(%i[post_categories create_post_category_import], :create?)
      outcome = PostCategories::CreatePostCategoryImport.run(params.fetch(:post_categories_import, {}))

      if outcome.valid?
        redirect_to :post_categories, notice: t('post_categories_import_job_successfully_queued')
      else
        @post_categories_import = outcome
        render :new, status: :unprocessable_entity
      end
    end
  end
end
