class RemoveImageDataFromEntities < ActiveRecord::Migration[6.1]
  def change
    remove_column :entities, :image_data, :jsonb
  end
end
