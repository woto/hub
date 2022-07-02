class AddMentionsCountToTopics < ActiveRecord::Migration[6.1]
  def change
    # TODO: remove after migration
    add_column :topics, :mentions_count, :integer, default: 0, null: false
  end
end
