class CreateLookupsRelations < ActiveRecord::Migration[6.1]
  def change
    create_table :lookups_relations do |t|
      t.references :lookup, null: false, foreign_key: true
      t.references :relation, polymorphic: true, null: false
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
