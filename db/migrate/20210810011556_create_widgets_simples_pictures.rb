class CreateWidgetsSimplesPictures < ActiveRecord::Migration[6.1]
  def change
    create_table :widgets_simples_pictures do |t|
      t.references :widgets_simple, null: false, foreign_key: true
      t.integer :order

      t.timestamps
    end
  end
end
