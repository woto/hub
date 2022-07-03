# TODO: remove after migration
class RemoveEntitiesCountFromMentions < ActiveRecord::Migration[6.1]
  def change
    remove_column :mentions, :entities_count, :integer
  end
end
