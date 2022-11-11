class RemoveIsMainFromEntitiesMentions < ActiveRecord::Migration[6.1]
  def change
    remove_column :entities_mentions, :is_main, :boolean
  end
end
