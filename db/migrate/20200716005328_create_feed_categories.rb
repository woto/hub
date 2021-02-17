# frozen_string_literal: true

class CreateFeedCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :feed_categories do |t|
      t.string :ext_id, null: false
      t.string :ext_parent_id
      t.string :name
      t.text :data
      t.uuid :attempt_uuid, null: false
      t.boolean :parent_not_found
      t.index %i[feed_id ext_id], unique: true
      t.references :feed, null: false, foreign_key: true

      t.timestamps
    end
  end
end
