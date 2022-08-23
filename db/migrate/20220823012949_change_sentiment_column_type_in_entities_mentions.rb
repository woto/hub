class ChangeSentimentColumnTypeInEntitiesMentions < ActiveRecord::Migration[6.1]
  def change
    change_column :entities_mentions, :sentiment, :float
  end
end
