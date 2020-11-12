class CreateAccountGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :account_groups do |t|
      t.timestamps
    end
  end
end
