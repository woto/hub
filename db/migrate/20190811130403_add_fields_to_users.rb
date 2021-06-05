# frozen_string_literal: true

class AddFieldsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :role, :integer, default: 0, null: false
    add_column :users, :posts_count, :integer, default: 0, null: false
    add_column :users, :checks_count, :integer, default: 0, null: false
    add_column :users, :favorites_count, :integer, default: 0, null: false
    add_column :users, :workspaces_count, :integer, default: 0, null: false
  end
end
