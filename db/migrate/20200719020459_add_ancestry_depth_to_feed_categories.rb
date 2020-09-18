# frozen_string_literal: true

class AddAncestryDepthToFeedCategories < ActiveRecord::Migration[6.0]
  def change
    add_column :feed_categories, :ancestry_depth, :integer, default: 0
  end
end
