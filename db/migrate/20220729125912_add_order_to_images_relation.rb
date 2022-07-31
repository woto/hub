class AddOrderToImagesRelation < ActiveRecord::Migration[6.1]
  def change
    add_column :images_relations, :order, :integer
  end
end
