class RemoveMentionsCountFromTopics < ActiveRecord::Migration[6.1]
  def change
    remove_column :topics, :mentions_count, :integer
  end
end
