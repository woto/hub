class CreateEntities < ActiveRecord::Migration[6.1]
  def change
    create_table :entities do |t|
      t.string :title
      t.jsonb :aliases, default: []
      t.integer :mentions_count, default: 0, null: false

      t.timestamps
    end
  end
end
