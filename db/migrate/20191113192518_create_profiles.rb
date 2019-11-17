class CreateProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :profiles do |t|
      t.text :name
      t.text :bio
      t.text :location
      t.jsonb :messengers
      t.jsonb :languages
      t.references :user, foreign_key: true, null: false

      t.timestamps
    end
  end
end
