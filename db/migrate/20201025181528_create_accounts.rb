class CreateAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :accounts do |t|
      t.string :name, null: false
      t.integer :kind, null: false
      t.integer :amount, null: false, default: 0
      t.references :subject, polymorphic: true, null: false
      t.integer :currency, null: false

      t.timestamps
    end
  end
end
