class CreatePostCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :post_categories do |t|
      # t.jsonb :title_i18n, default: {}
      t.string :title, null: false
      t.references :realm, null: false, foreign_key: true
      t.integer :priority, null: false, default: 0

      t.timestamps
    end
  end
end
