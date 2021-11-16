class CreateEntitiesMentions < ActiveRecord::Migration[6.1]
  def change
    create_table :entities_mentions do |t|
      t.references :entity, null: false, foreign_key: true
      t.references :mention, null: false, foreign_key: true

      t.timestamps
    end
  end
end
