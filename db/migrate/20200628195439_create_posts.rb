# frozen_string_literal: true

class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.integer :status, null: false
      t.references :user, null: false, foreign_key: true
      t.integer :price, null: false, default: 0
      t.jsonb :extra_options

      t.timestamps
    end
  end
end
