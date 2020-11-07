class AddNameToTransactionGroup < ActiveRecord::Migration[6.0]
  def change
    add_column :transaction_groups, :kind, :integer
  end
end
