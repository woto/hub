class AddFavoritesItemsCountToFavorites < ActiveRecord::Migration[6.0]
  def change
    add_column :favorites, :favorites_items_count, :integer
  end
end
