class AddDescriptionToFavorites < ActiveRecord::Migration[7.0]
  def change
    add_column :favorites, :description, :text
  end
end
