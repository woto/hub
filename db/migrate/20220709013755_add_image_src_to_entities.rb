class AddImageSrcToEntities < ActiveRecord::Migration[6.1]
  def change
    add_column :entities, :image_src, :string
  end
end
