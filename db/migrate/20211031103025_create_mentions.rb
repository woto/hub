class CreateMentions < ActiveRecord::Migration[6.1]
  def change
    create_table :mentions do |t|
      t.references :user, null: false, foreign_key: true
      t.text :url
      t.jsonb :tags, default: []
      t.datetime :published_at
      t.integer :kind, null: false
      t.integer :sentiment, null: false
      t.integer :entities_count, default: 0, null: false

      t.timestamps
    end
  end
end
