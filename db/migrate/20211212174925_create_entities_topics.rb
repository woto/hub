# frozen_string_literal: true

# TODO: remove after migration
class CreateEntitiesTopics < ActiveRecord::Migration[6.1]
  def change
    create_table :entities_topics do |t|
      t.references :entity, null: false, foreign_key: true
      t.references :topic, null: false, foreign_key: true

      t.timestamps
    end
  end
end
