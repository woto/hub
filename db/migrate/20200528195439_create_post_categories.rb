class CreatePostCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :post_categories do |t|
      t.string :title, null: false
      t.references :realm, null: false, foreign_key: true
      t.integer :priority, null: false, default: 0
      t.integer :posts_count, default: 0, null: false
      t.integer :ancestry_depth, default: 0

      t.timestamps
    end
  end
end
