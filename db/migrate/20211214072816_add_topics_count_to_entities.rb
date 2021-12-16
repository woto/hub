class AddTopicsCountToEntities < ActiveRecord::Migration[6.1]
  def change
    add_column :entities, :topics_count, :integer, default: 0, null: false
  end
end
