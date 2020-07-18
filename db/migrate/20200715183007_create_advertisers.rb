class CreateAdvertisers < ActiveRecord::Migration[6.0]
  def change
    create_table :advertisers do |t|
      t.integer :network, null: false
      t.string :ext_id, null: false
      t.string :name
      t.jsonb :data
      t.datetime :last_synced_at
      t.index [:network, :ext_id], unique: true

      t.timestamps
    end
  end
end
