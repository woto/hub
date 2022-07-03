class CreateImagesRelations < ActiveRecord::Migration[6.1]
  def change
    create_table :images_relations do |t|
      t.references :image, null: false, foreign_key: true
      t.references :relation, polymorphic: true, null: false
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
