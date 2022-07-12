class AddMentionDateToEntitiesMentions < ActiveRecord::Migration[6.1]
  def change
    add_column :entities_mentions, :mention_date, :datetime
  end
end
