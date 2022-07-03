class RemoveTopicsCountFromEntities < ActiveRecord::Migration[6.1]
  def change
    remove_column :entities, :topics_count, :integer
  end
end
