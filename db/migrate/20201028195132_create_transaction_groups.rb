class CreateTransactionGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :transaction_groups do |t|
      t.references :object, polymorphic: true
      t.jsonb :object_hash

      t.timestamps
    end
  end
end
