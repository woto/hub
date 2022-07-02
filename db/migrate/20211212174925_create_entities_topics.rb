# frozen_string_literal: true

class CreateEntitiesTopics < ActiveRecord::Migration[6.1]
  def change
    # TODO: remove after migration
    create_table :entities_topics do |t|
      t.references :entity, null: false, foreign_key: true
      t.references :topic, null: false, foreign_key: true

      t.timestamps
    end
  end
end
