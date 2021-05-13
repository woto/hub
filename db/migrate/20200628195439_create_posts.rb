# frozen_string_literal: true

class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.references :post_category, null: false, foreign_key: true
      t.references :exchange_rate, null: false, foreign_key: true
      t.integer :currency, null: false
      t.string :title, null: false
      t.integer :status, null: false
      t.references :user, null: false, foreign_key: true
      t.decimal :price, null: false
      t.jsonb :extra_options
      t.references :realm, null: false, foreign_key: true
      t.datetime :published_at, null: false
      t.jsonb :tags, default: []
      t.integer :priority, null: false, default: 0

      t.timestamps
    end
  end
end
