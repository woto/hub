class AddIsPublicToFavorites < ActiveRecord::Migration[7.0]
  def change
    add_column :favorites, :is_public, :boolean, default: false
  end
end
