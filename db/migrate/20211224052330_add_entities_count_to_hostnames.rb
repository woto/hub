class AddEntitiesCountToHostnames < ActiveRecord::Migration[6.1]
  def change
    add_column :hostnames, :entities_count, :integer, default: 0, null: false
  end
end
