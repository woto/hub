class AddImageDataToEntities < ActiveRecord::Migration[6.1]
  def change
    add_column :entities, :image_data, :jsonb
    add_index :entities, :image_data, using: :gin
  end
end
