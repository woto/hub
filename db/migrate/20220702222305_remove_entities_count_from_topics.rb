class RemoveEntitiesCountFromTopics < ActiveRecord::Migration[6.1]
  def change
    remove_column :topics, :entities_count, :integer
  end
end
