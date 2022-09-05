class CreateComplains < ActiveRecord::Migration[6.1]
  def change
    create_table :complains do |t|
      t.references :user, foreign_key: true
      t.jsonb :data
      t.text :text

      t.timestamps
    end
  end
end
