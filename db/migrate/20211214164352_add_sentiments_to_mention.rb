class AddSentimentsToMention < ActiveRecord::Migration[6.1]
  def change
    # TODO remove later
    add_column :mentions, :sentiments, :jsonb, default: []
  end
end
