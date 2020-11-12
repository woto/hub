class AddFavoritesItemsCounterToFavorites < ActiveRecord::Migration[6.0]
  def change
    add_column :favorites, :favorites_items, :integer, default: 0, null: false
  end
end
