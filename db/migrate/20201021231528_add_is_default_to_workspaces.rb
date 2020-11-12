class AddIsDefaultToWorkspaces < ActiveRecord::Migration[6.0]
  def change
    add_column :workspaces, :is_default, :boolean, default: false, null: false
  end
end
