# frozen_string_literal: true

class AddAncestryToFeedCategories < ActiveRecord::Migration[6.0]
  def change
    add_column :feed_categories, :ancestry, :string
    add_index :feed_categories, :ancestry
  end
end
