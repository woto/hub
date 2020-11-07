class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.references :debit, null: false, foreign_key: { to_table: :accounts }
      t.integer :debit_amount, null: false

      t.references :credit, null: false, foreign_key: { to_table: :accounts }
      t.integer :credit_amount, null: false

      t.integer :amount, null: false

      t.timestamps
    end
  end
end
