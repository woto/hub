class CreateCites < ActiveRecord::Migration[6.1]
  def change
    create_table :cites do |t|
      t.references :user, null: false, foreign_key: true
      t.references :entity, null: false, foreign_key: true
      # t.string :location_url
      t.string :title
      t.text :intro
      t.string :text_start
      t.string :text_end
      t.string :prefix
      t.string :suffix
      t.string :link_url
      t.integer :relevance
      t.integer :sentiment
      t.references :mention, null: false, foreign_key: true

      t.timestamps
    end
  end
end
