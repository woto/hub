class CreateImages < ActiveRecord::Migration[6.1]
  def change
    create_table :images do |t|
      t.references :imageable, polymorphic: true, null: false
      t.jsonb :image_data

      t.timestamps
    end
  end
end
