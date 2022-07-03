class CreateEntities < ActiveRecord::Migration[6.1]
  def change
    create_table :entities do |t|
      t.string :title
      t.jsonb :aliases, default: []
      # TODO: rename to entities_mentions_count after migration
      t.integer :mentions_count, default: 0, null: false

      t.timestamps
    end
  end
end
