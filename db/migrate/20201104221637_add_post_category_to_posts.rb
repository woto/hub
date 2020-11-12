class AddPostCategoryToPosts < ActiveRecord::Migration[6.0]
  def change
    add_reference :posts, :post_category, null: false, foreign_key: true
  end
end
