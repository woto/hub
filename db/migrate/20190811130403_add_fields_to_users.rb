# frozen_string_literal: true

class AddFieldsToUsers < ActiveRecord::Migration[5.2]
  def change
    change_table :users, bulk: true do |t|
      t.integer :role, default: 0, null: false
      t.integer :posts_count, default: 0, null: false
      t.integer :checks_count, default: 0, null: false
      t.integer :favorites_count, default: 0, null: false
      t.integer :workspaces_count, default: 0, null: false
      t.integer :profiles_count, default: 0, null: false
    end
  end
end
