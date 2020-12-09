class CreateAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :accounts do |t|
      t.integer :code, null: false
      t.uuid :identifier
      t.string :comment, null: false
      t.integer :kind, null: false
      t.decimal :amount, null: false, default: 0
      t.references :subject, polymorphic: true, null: false
      t.integer :currency, null: false

      t.index [:identifier, :kind, :currency, :subject_id, :subject_type], unique: true,
              name: :account_set_uniqueness

      t.timestamps
    end
  end
end
