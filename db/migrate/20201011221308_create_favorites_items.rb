class CreateFavoritesItems < ActiveRecord::Migration[6.0]
  def change
    create_table :favorites_items do |t|
      t.references :favorite, null: false, foreign_key: true
      t.string :ext_id
      t.jsonb :data
      t.timestamps
    end
  end
end
