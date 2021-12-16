class RemoveSentimentColumnFromMentions < ActiveRecord::Migration[6.1]
  def change
    remove_column :mentions, :sentiment, :integer
  end
end
