class CreateFavorites < ActiveRecord::Migration[6.0]
  def change
    create_table :favorites do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.integer :kind, null: false
      t.integer :favorites_items, default: 0, null: false
      t.integer :favorites_items_count

      t.timestamps
    end
  end
end
