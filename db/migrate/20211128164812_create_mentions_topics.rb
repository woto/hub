class CreateMentionsTopics < ActiveRecord::Migration[6.1]
  def change
    create_table :mentions_topics do |t|
      t.references :mention, null: false, foreign_key: true
      t.references :topic, null: false, foreign_key: true

      t.timestamps
    end
  end
end
