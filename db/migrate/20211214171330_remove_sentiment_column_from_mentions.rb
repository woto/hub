class RemoveSentimentColumnFromMentions < ActiveRecord::Migration[6.1]
  def change
    # TODO remove later
    remove_column :mentions, :sentiment, :integer
  end
end
