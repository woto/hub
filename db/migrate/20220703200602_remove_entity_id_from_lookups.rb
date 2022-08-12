class RemoveEntityIdFromLookups < ActiveRecord::Migration[6.1]
  def change
    remove_reference :lookups, :entity, null: false, foreign_key: true
  end
end
