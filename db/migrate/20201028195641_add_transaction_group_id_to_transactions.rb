class AddTransactionGroupIdToTransactions < ActiveRecord::Migration[6.0]
  def change
    add_reference :transactions, :transaction_group, null: false, foreign_key: true
  end
end
