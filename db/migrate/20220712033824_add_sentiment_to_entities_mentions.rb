class AddSentimentToEntitiesMentions < ActiveRecord::Migration[6.1]
  def change
    add_column :entities_mentions, :sentiment, :integer
  end
end
