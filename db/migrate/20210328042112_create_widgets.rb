class CreateWidgets < ActiveRecord::Migration[6.1]
  def change
    create_table :widgets do |t|
      t.references :user, null: false, foreign_key: true
      t.references :widgetable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
