# frozen_string_literal: true

class CreateAdvertisers < ActiveRecord::Migration[6.0]
  def change
    create_table :advertisers do |t|
      t.string :type
      t.string :ext_id
      t.string :name
      t.jsonb :data
      t.datetime :synced_at
      t.boolean :is_active, null: false, default: true

      t.integer :gdeslon_id
      t.string :gdeslon_name
      t.text :gdeslon_short_description
      t.text :gdeslon_description
      t.string :gdeslon_url
      t.string :gdeslon_conditions
      t.boolean :gdeslon_is_green
      t.string :gdeslon_gs_commission_mark
      t.string :gdeslon_country
      t.string :gdeslon_kind
      t.jsonb :gdeslon_categories
      t.string :gdeslon_logo_file_name
      t.string :gdeslon_affiliate_link
      t.jsonb :gdeslon_traffic_types
      t.jsonb :gdeslon_tariffs

      t.integer :admitad_id
      t.string :admitad_name
      t.string :admitad_site_url
      t.text :admitad_description
      t.text :admitad_raw_description
      t.string :admitad_currency
      t.float :admitad_rating
      t.float :admitad_ecpc
      t.float :admitad_epc
      t.float :admitad_cr
      t.jsonb :admitad_actions
      t.jsonb :admitad_regions
      t.jsonb :admitad_categories
      t.string :admitad_status
      t.string :admitad_image
      t.float :admitad_ecpc_trend
      t.float :admitad_epc_trend
      t.string :admitad_cr_trend
      t.boolean :admitad_exclusive
      t.datetime :admitad_activation_date
      t.datetime :admitad_modified_date
      t.boolean :admitad_denynewwms
      t.integer :admitad_goto_cookie_lifetime
      t.boolean :admitad_retag
      t.boolean :admitad_show_products_links
      t.string :admitad_landing_code
      t.string :admitad_landing_title
      t.boolean :admitad_geotargeting
      t.string :admitad_max_hold_time
      t.jsonb :admitad_traffics
      t.integer :admitad_avg_hold_time
      t.integer :admitad_avg_money_transfer_time
      t.boolean :admitad_allow_deeplink
      t.boolean :admitad_coupon_iframe_denied
      t.string :admitad_action_testing_limit
      t.string :admitad_mobile_device_type
      t.string :admitad_mobile_os
      t.string :admitad_mobile_os_type
      t.jsonb :admitad_action_countries
      t.boolean :admitad_allow_actions_all_countries
      t.string :admitad_connection_status
      t.string :admitad_gotolink
      t.string :admitad_products_xml_link
      t.string :admitad_products_csv_link
      t.boolean :admitad_moderation
      t.jsonb :admitad_feeds_info
      t.jsonb :admitad_actions_detail
      t.string :admitad_actions_limit
      t.string :admitad_actions_limit_24

      t.index %i[type ext_id], unique: true

      t.timestamps
    end
  end
end
