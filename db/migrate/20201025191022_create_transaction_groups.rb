class CreateTransactionGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :transaction_groups do |t|
      t.integer :kind, null: false
      t.timestamps
    end
  end
end
