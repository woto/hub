# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_11_04_221637) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_groups", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "accounts", force: :cascade do |t|
    t.string "name", null: false
    t.integer "kind", null: false
    t.integer "amount", default: 0, null: false
    t.string "subject_type", null: false
    t.bigint "subject_id", null: false
    t.integer "currency", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "code", null: false
    t.index ["subject_type", "subject_id"], name: "index_accounts_on_subject_type_and_subject_id"
  end

  create_table "action_mailbox_inbound_emails", force: :cascade do |t|
    t.integer "status", default: 0, null: false
    t.string "message_id", null: false
    t.string "message_checksum", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["message_id", "message_checksum"], name: "index_action_mailbox_inbound_emails_uniqueness", unique: true
  end

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "advertisers", force: :cascade do |t|
    t.string "type"
    t.string "ext_id"
    t.string "name"
    t.jsonb "data"
    t.datetime "synced_at"
    t.integer "gdeslon_id"
    t.string "gdeslon_name"
    t.text "gdeslon_short_description"
    t.text "gdeslon_description"
    t.string "gdeslon_url"
    t.string "gdeslon_conditions"
    t.boolean "gdeslon_is_green"
    t.string "gdeslon_gs_commission_mark"
    t.string "gdeslon_country"
    t.string "gdeslon_kind"
    t.jsonb "gdeslon_categories"
    t.string "gdeslon_logo_file_name"
    t.string "gdeslon_affiliate_link"
    t.jsonb "gdeslon_traffic_types"
    t.jsonb "gdeslon_tariffs"
    t.integer "admitad_id"
    t.string "admitad_name"
    t.string "admitad_site_url"
    t.text "admitad_description"
    t.text "admitad_raw_description"
    t.string "admitad_currency"
    t.float "admitad_rating"
    t.float "admitad_ecpc"
    t.float "admitad_epc"
    t.float "admitad_cr"
    t.jsonb "admitad_actions"
    t.jsonb "admitad_regions"
    t.jsonb "admitad_categories"
    t.string "admitad_status"
    t.string "admitad_image"
    t.float "admitad_ecpc_trend"
    t.float "admitad_epc_trend"
    t.string "admitad_cr_trend"
    t.boolean "admitad_exclusive"
    t.datetime "admitad_activation_date"
    t.datetime "admitad_modified_date"
    t.boolean "admitad_denynewwms"
    t.integer "admitad_goto_cookie_lifetime"
    t.boolean "admitad_retag"
    t.boolean "admitad_show_products_links"
    t.string "admitad_landing_code"
    t.string "admitad_landing_title"
    t.boolean "admitad_geotargeting"
    t.string "admitad_max_hold_time"
    t.jsonb "admitad_traffics"
    t.integer "admitad_avg_hold_time"
    t.integer "admitad_avg_money_transfer_time"
    t.boolean "admitad_allow_deeplink"
    t.boolean "admitad_coupon_iframe_denied"
    t.string "admitad_action_testing_limit"
    t.string "admitad_mobile_device_type"
    t.string "admitad_mobile_os"
    t.string "admitad_mobile_os_type"
    t.jsonb "admitad_action_countries"
    t.boolean "admitad_allow_actions_all_countries"
    t.string "admitad_connection_status"
    t.string "admitad_gotolink"
    t.string "admitad_products_xml_link"
    t.string "admitad_products_csv_link"
    t.boolean "admitad_moderation"
    t.jsonb "admitad_feeds_info"
    t.jsonb "admitad_actions_detail"
    t.string "admitad_actions_limit"
    t.string "admitad_actions_limit_24"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["type", "ext_id"], name: "index_advertisers_on_type_and_ext_id", unique: true
  end

  create_table "favorites", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name"
    t.integer "kind"
    t.boolean "is_default", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "favorites_items", default: 0, null: false
    t.integer "favorites_items_count"
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "favorites_items", force: :cascade do |t|
    t.bigint "favorite_id", null: false
    t.string "ext_id"
    t.jsonb "data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["favorite_id"], name: "index_favorites_items_on_favorite_id"
  end

  create_table "feed_categories", force: :cascade do |t|
    t.string "ext_id", null: false
    t.string "ext_parent_id"
    t.string "name"
    t.jsonb "data"
    t.uuid "attempt_uuid", null: false
    t.boolean "parent_not_found"
    t.bigint "feed_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "ancestry"
    t.integer "ancestry_depth", default: 0
    t.index ["ancestry"], name: "index_feed_categories_on_ancestry"
    t.index ["feed_id", "ext_id"], name: "index_feed_categories_on_feed_id_and_ext_id", unique: true
    t.index ["feed_id"], name: "index_feed_categories_on_feed_id"
  end

  create_table "feed_logs", force: :cascade do |t|
    t.bigint "feed_id", null: false
    t.bigint "feed_id_before"
    t.bigint "feed_id_after"
    t.datetime "feed_advertiser_updated_at_before"
    t.datetime "feed_advertiser_updated_at_after"
    t.uuid "feed_attempt_uuid_before"
    t.uuid "feed_attempt_uuid_after"
    t.integer "feed_categories_count_before"
    t.integer "feed_categories_count_after"
    t.jsonb "feed_data_before"
    t.jsonb "feed_data_after"
    t.string "feed_error_class_before"
    t.string "feed_error_class_after"
    t.text "feed_error_text_before"
    t.text "feed_error_text_after"
    t.string "feed_index_name_before"
    t.string "feed_index_name_after"
    t.string "feed_language_before"
    t.string "feed_language_after"
    t.integer "feed_locked_by_pid_before"
    t.integer "feed_locked_by_pid_after"
    t.string "feed_name_before"
    t.string "feed_name_after"
    t.datetime "feed_network_updated_at_before"
    t.datetime "feed_network_updated_at_after"
    t.integer "feed_offers_count_before"
    t.integer "feed_offers_count_after"
    t.datetime "feed_processing_finished_at_before"
    t.datetime "feed_processing_finished_at_after"
    t.datetime "feed_processing_started_at_before"
    t.datetime "feed_processing_started_at_after"
    t.datetime "feed_succeeded_at_before"
    t.datetime "feed_succeeded_at_after"
    t.datetime "feed_synced_at_before"
    t.datetime "feed_synced_at_after"
    t.string "feed_url_before"
    t.string "feed_url_after"
    t.string "feed_operation_before"
    t.string "feed_operation_after"
    t.datetime "feed_created_at_before"
    t.datetime "feed_created_at_after"
    t.datetime "feed_updated_at_before"
    t.datetime "feed_updated_at_after"
    t.bigint "feed_advertiser_id_before"
    t.bigint "feed_advertiser_id_after"
    t.string "feed_ext_id_before"
    t.string "feed_ext_id_after"
    t.string "feed_priority_before"
    t.string "feed_priority_after"
    t.string "feed_downloaded_file_type_before"
    t.string "feed_downloaded_file_type_after"
    t.string "feed_xml_file_path_before"
    t.string "feed_xml_file_path_after"
    t.boolean "feed_is_active_before"
    t.boolean "feed_is_active_after"
    t.bigint "feed_downloaded_file_size_before"
    t.bigint "feed_downloaded_file_size_after"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["feed_id"], name: "index_feed_logs_on_feed_id"
  end

  create_table "feeds", force: :cascade do |t|
    t.bigint "advertiser_id", null: false
    t.string "operation", null: false
    t.string "ext_id"
    t.string "name", null: false
    t.string "url", null: false
    t.string "error_class"
    t.text "error_text"
    t.integer "locked_by_pid", default: 0, null: false
    t.string "language"
    t.string "index_name"
    t.uuid "attempt_uuid"
    t.jsonb "data"
    t.datetime "processing_started_at"
    t.datetime "processing_finished_at"
    t.datetime "synced_at"
    t.datetime "succeeded_at"
    t.datetime "network_updated_at"
    t.datetime "advertiser_updated_at"
    t.integer "offers_count"
    t.integer "categories_count"
    t.integer "priority", default: 0, null: false
    t.string "xml_file_path"
    t.string "downloaded_file_type"
    t.boolean "is_active", default: true
    t.bigint "downloaded_file_size"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["advertiser_id"], name: "index_feeds_on_advertiser_id"
  end

  create_table "identities", force: :cascade do |t|
    t.string "uid", null: false
    t.string "provider", null: false
    t.bigint "user_id", null: false
    t.jsonb "auth", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_identities_on_user_id"
  end

  create_table "offer_embeds", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name"
    t.string "url"
    t.text "description"
    t.string "picture"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_offer_embeds_on_user_id"
  end

  create_table "post_categories", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "ancestry"
    t.index ["ancestry"], name: "index_post_categories_on_ancestry"
  end

  create_table "posts", force: :cascade do |t|
    t.string "title", null: false
    t.integer "status", null: false
    t.bigint "user_id", null: false
    t.integer "price", default: 0, null: false
    t.jsonb "extra_options"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "language"
    t.bigint "post_category_id", null: false
    t.index ["post_category_id"], name: "index_posts_on_post_category_id"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.string "name"
    t.text "bio"
    t.jsonb "messengers"
    t.jsonb "languages"
    t.string "time_zone"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "transaction_groups", force: :cascade do |t|
    t.string "object_type"
    t.bigint "object_id"
    t.jsonb "object_hash"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "kind"
    t.index ["object_type", "object_id"], name: "index_transaction_groups_on_object_type_and_object_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "debit_id", null: false
    t.integer "debit_amount", null: false
    t.bigint "credit_id", null: false
    t.integer "credit_amount", null: false
    t.integer "amount", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "transaction_group_id", null: false
    t.index ["credit_id"], name: "index_transactions_on_credit_id"
    t.index ["debit_id"], name: "index_transactions_on_debit_id"
    t.index ["transaction_group_id"], name: "index_transactions_on_transaction_group_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "workspaces", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "controller"
    t.string "name"
    t.string "path"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "is_default", default: false, null: false
    t.index ["user_id"], name: "index_workspaces_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "favorites", "users"
  add_foreign_key "favorites_items", "favorites"
  add_foreign_key "feed_categories", "feeds"
  add_foreign_key "feed_logs", "feeds"
  add_foreign_key "feeds", "advertisers"
  add_foreign_key "identities", "users"
  add_foreign_key "offer_embeds", "users"
  add_foreign_key "posts", "post_categories"
  add_foreign_key "posts", "users"
  add_foreign_key "profiles", "users"
  add_foreign_key "transactions", "accounts", column: "credit_id"
  add_foreign_key "transactions", "accounts", column: "debit_id"
  add_foreign_key "transactions", "transaction_groups"
  add_foreign_key "workspaces", "users"
end
