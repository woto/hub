class AddAncestryToPostCategories < ActiveRecord::Migration[6.0]
  def change
    add_column :post_categories, :ancestry, :string
    add_index :post_categories, :ancestry
  end
end
