class AddCodeToAccounts < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :code, :integer, null: false
  end
end
