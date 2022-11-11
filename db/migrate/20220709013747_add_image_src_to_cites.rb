class AddImageSrcToCites < ActiveRecord::Migration[6.1]
  def change
    add_column :cites, :image_src, :string
  end
end
