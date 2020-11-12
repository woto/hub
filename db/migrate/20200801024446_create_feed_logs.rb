# frozen_string_literal: true

class CreateFeedLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :feed_logs do |t|
      t.references :feed, null: false, foreign_key: true

      t.bigint :feed_id_before
      t.bigint :feed_id_after
      t.datetime :feed_advertiser_updated_at_before
      t.datetime :feed_advertiser_updated_at_after
      t.uuid :feed_attempt_uuid_before
      t.uuid :feed_attempt_uuid_after
      t.integer :feed_categories_count_before
      t.integer :feed_categories_count_after
      t.jsonb :feed_data_before
      t.jsonb :feed_data_after
      t.string :feed_error_class_before
      t.string :feed_error_class_after
      t.text :feed_error_text_before
      t.text :feed_error_text_after
      t.string :feed_index_name_before
      t.string :feed_index_name_after
      t.string :feed_language_before
      t.string :feed_language_after
      t.integer :feed_locked_by_pid_before
      t.integer :feed_locked_by_pid_after
      t.string :feed_name_before
      t.string :feed_name_after
      t.datetime :feed_network_updated_at_before
      t.datetime :feed_network_updated_at_after
      t.integer :feed_offers_count_before
      t.integer :feed_offers_count_after
      t.datetime :feed_processing_finished_at_before
      t.datetime :feed_processing_finished_at_after
      t.datetime :feed_processing_started_at_before
      t.datetime :feed_processing_started_at_after
      t.datetime :feed_succeeded_at_before
      t.datetime :feed_succeeded_at_after
      t.datetime :feed_synced_at_before
      t.datetime :feed_synced_at_after
      t.string :feed_url_before
      t.string :feed_url_after
      t.string :feed_operation_before
      t.string :feed_operation_after
      t.datetime :feed_created_at_before
      t.datetime :feed_created_at_after
      t.datetime :feed_updated_at_before
      t.datetime :feed_updated_at_after
      t.bigint :feed_advertiser_id_before
      t.bigint :feed_advertiser_id_after
      t.string :feed_ext_id_before
      t.string :feed_ext_id_after
      t.string :feed_priority_before
      t.string :feed_priority_after
      t.string :feed_downloaded_file_type_before
      t.string :feed_downloaded_file_type_after
      t.string :feed_xml_file_path_before
      t.string :feed_xml_file_path_after
      t.boolean :feed_is_active_before
      t.boolean :feed_is_active_after
      t.bigint :feed_downloaded_file_size_before
      t.bigint :feed_downloaded_file_size_after
      t.timestamps
    end
  end
end
