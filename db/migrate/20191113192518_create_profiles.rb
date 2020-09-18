# frozen_string_literal: true

class CreateProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :profiles do |t|
      t.string :name
      t.text :bio
      t.string :location
      t.jsonb :messengers
      t.jsonb :languages
      t.string :time_zone
      t.jsonb :displayed_columns
      t.references :user, foreign_key: true, null: false

      t.timestamps
    end
  end
end
