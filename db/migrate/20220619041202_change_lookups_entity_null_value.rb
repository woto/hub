class ChangeLookupsEntityNullValue < ActiveRecord::Migration[6.1]
  def change
    change_column_null :lookups, :entity_id, true
  end
end
