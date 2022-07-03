# TODO: remove after migration

class DropMentionsTopics < ActiveRecord::Migration[6.1]
  def up
    drop_table :mentions_topics
  end
end
