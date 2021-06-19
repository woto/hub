class CreateFavoritesItems < ActiveRecord::Migration[6.0]
  def change
    create_table :favorites_items do |t|
      t.references :favorite, null: false, foreign_key: true
      t.integer :kind, null: false
      t.string :ext_id, null: false
      # t.jsonb :data
      t.timestamps
    end
  end
end
