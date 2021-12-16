# frozen_string_literal: true

class CopySentimentToSentiments < ActiveRecord::Migration[6.1]
  def change
    # TODO: remove after migration
    reversible do |dir|
      dir.up do
        Mention.find_each do |mention|
          val = Mention::SENTIMENTS[mention.sentiment]
          mention.sentiments = val ? [val] : []
          mention.save!
        end
      end
    end
  end
end
