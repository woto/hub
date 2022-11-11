class CreateImages < ActiveRecord::Migration[6.1]
  def change
    create_table :images do |t|
      t.jsonb :image_data
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
