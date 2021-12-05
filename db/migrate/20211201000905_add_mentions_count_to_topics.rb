class AddMentionsCountToTopics < ActiveRecord::Migration[6.1]
  def change
    add_column :topics, :mentions_count, :integer, default: 0, null: false
  end
end
