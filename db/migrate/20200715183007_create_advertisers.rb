# frozen_string_literal: true

class CreateAdvertisers < ActiveRecord::Migration[6.0]
  def change
    create_table :advertisers do |t|
      t.integer :network
      t.string :ext_id
      t.string :name
      t.text :raw
      t.datetime :synced_at
      t.boolean :is_active, null: false, default: true

      t.index %i[network ext_id], unique: true

      t.timestamps
    end
  end
end
