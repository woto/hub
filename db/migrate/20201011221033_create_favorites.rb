class CreateFavorites < ActiveRecord::Migration[6.0]
  def change
    create_table :favorites do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.integer :kind
      t.boolean :is_default, default: false

      t.timestamps
    end
  end
end
