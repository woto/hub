class CreateDescriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :descriptions do |t|
      t.integer :advertiser_id, null: false
      t.integer :feed_id, null: false
      t.string :offer_id, null: false
      t.text :title, null: false
      t.text :description

      t.timestamps
    end
  end
end
