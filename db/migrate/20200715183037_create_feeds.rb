class CreateFeeds < ActiveRecord::Migration[6.0]
  def change
    create_table :feeds do |t|
      t.references :advertiser, null: false, foreign_key: true
      t.string :ext_id, null: false
      t.string :name
      t.string :url, null: false
      t.integer :locked_by_pid, null: false, default: 0
      t.text :last_error
      t.uuid :last_attempt_uuid
      t.datetime :processing_started_at
      t.datetime :processing_finished_at
      t.jsonb :data
      t.datetime :last_synced_at, null: false

      t.timestamps
    end
  end
end
