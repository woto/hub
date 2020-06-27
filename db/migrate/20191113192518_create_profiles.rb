class CreateProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :profiles do |t|
      t.string :name
      t.text :bio
      t.string :location
      t.jsonb :messengers
      t.jsonb :languages
      t.references :user, foreign_key: true, null: false

      t.timestamps
    end
  end
end
