class AddTopicsRelationsCountToTopics < ActiveRecord::Migration[6.1]
  def change
    add_column :topics, :topics_relations_count, :integer
  end
end
