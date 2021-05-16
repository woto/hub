class CreateChecks < ActiveRecord::Migration[6.0]
  def change
    create_table :checks do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :amount, null: false
      t.integer :currency, null: false
      t.integer :status, null: false

      t.timestamps
    end
  end
end
