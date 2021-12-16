# frozen_string_literal: true

class CreateEntitiesEntities < ActiveRecord::Migration[6.1]
  def change
    create_table :entities_entities do |t|
      t.references :parent, null: false, foreign_key: { to_table: :entities }
      t.references :child, null: false, foreign_key: { to_table: :entities }

      t.timestamps
    end
  end
end
