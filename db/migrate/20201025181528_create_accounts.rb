# frozen_string_literal: true

class CreateAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :accounts do |t|
      t.integer :code, null: false
      t.decimal :amount, null: false, default: 0
      t.references :subjectable, polymorphic: true, null: false
      t.integer :currency, null: false

      t.index %i[code currency subjectable_id subjectable_type],
              unique: true,
              name: :account_set_uniqueness

      t.timestamps
    end
  end
end
