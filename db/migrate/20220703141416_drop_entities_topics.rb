# TODO: remove after migration

class DropEntitiesTopics < ActiveRecord::Migration[6.1]
  def up
    drop_table :entities_topics
  end
end
