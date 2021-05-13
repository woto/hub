# frozen_string_literal: true

class CreateFeeds < ActiveRecord::Migration[6.0]
  def change
    create_table :feeds do |t|
      t.references :advertiser, null: false, foreign_key: true
      t.string :operation, null: false
      t.string :ext_id
      t.string :name, null: false
      t.string :url, null: false
      t.string :error_class
      t.text :error_text
      t.integer :locked_by_pid, null: false, default: 0
      t.string :language
      t.uuid :attempt_uuid
      t.text :raw
      t.datetime :processing_started_at
      t.datetime :processing_finished_at
      t.datetime :synced_at
      t.datetime :succeeded_at
      t.integer :offers_count
      t.integer :categories_count
      t.integer :feed_categories_count, default: 0
      t.integer :priority, null: false, default: 0
      t.string :xml_file_path
      t.string :downloaded_file_type
      t.boolean :is_active, null: false, default: true
      t.bigint :downloaded_file_size

      t.timestamps
    end
  end
end
