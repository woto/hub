# frozen_string_literal: true

class CreateSubjects < ActiveRecord::Migration[6.0]
  def change
    create_table :subjects do |t|
      t.integer :identifier, null: false, index: { unique: true }
      t.timestamps
    end
  end
end
