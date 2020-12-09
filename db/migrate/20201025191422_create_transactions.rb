class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.references :debit, null: false, foreign_key: { to_table: :accounts }
      t.decimal :debit_amount, null: false
      t.string :debit_label

      t.references :credit, null: false, foreign_key: { to_table: :accounts }
      t.decimal :credit_amount, null: false
      t.string :credit_label

      t.decimal :amount, null: false

      t.references :obj, polymorphic: true
      t.jsonb :obj_hash

      t.references :transaction_group, null: false, foreign_key: true
      t.references :responsible, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
