class AddIsMainToEntitiesMentions < ActiveRecord::Migration[6.1]
  def change
    add_column :entities_mentions, :is_main, :boolean, null: false, default: false
  end
end
