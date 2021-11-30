class CreateLookups < ActiveRecord::Migration[6.1]
  def change
    create_table :lookups do |t|
      t.string :title, null: false
      t.references :entity, null: false, foreign_key: true

      t.timestamps
    end
  end
end
