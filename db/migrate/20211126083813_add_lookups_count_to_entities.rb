class AddLookupsCountToEntities < ActiveRecord::Migration[6.1]
  def change
    add_column :entities, :lookups_count, :integer, default: 0, null: false
  end
end
