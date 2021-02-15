# frozen_string_literal: true

# == Schema Information
#
# Table name: advertisers
#
#  id                                  :bigint           not null, primary key
#  admitad_action_countries            :jsonb
#  admitad_action_testing_limit        :string
#  admitad_actions                     :jsonb
#  admitad_actions_detail              :jsonb
#  admitad_actions_limit               :string
#  admitad_actions_limit_24            :string
#  admitad_activation_date             :datetime
#  admitad_allow_actions_all_countries :boolean
#  admitad_allow_deeplink              :boolean
#  admitad_avg_hold_time               :integer
#  admitad_avg_money_transfer_time     :integer
#  admitad_categories                  :jsonb
#  admitad_connection_status           :string
#  admitad_coupon_iframe_denied        :boolean
#  admitad_cr                          :float
#  admitad_cr_trend                    :string
#  admitad_currency                    :string
#  admitad_denynewwms                  :boolean
#  admitad_description                 :text
#  admitad_ecpc                        :float
#  admitad_ecpc_trend                  :float
#  admitad_epc                         :float
#  admitad_epc_trend                   :float
#  admitad_exclusive                   :boolean
#  admitad_feeds_info                  :jsonb
#  admitad_geotargeting                :boolean
#  admitad_goto_cookie_lifetime        :integer
#  admitad_gotolink                    :string
#  admitad_image                       :string
#  admitad_landing_code                :string
#  admitad_landing_title               :string
#  admitad_max_hold_time               :string
#  admitad_mobile_device_type          :string
#  admitad_mobile_os                   :string
#  admitad_mobile_os_type              :string
#  admitad_moderation                  :boolean
#  admitad_modified_date               :datetime
#  admitad_name                        :string
#  admitad_products_csv_link           :string
#  admitad_products_xml_link           :string
#  admitad_rating                      :float
#  admitad_raw_description             :text
#  admitad_regions                     :jsonb
#  admitad_retag                       :boolean
#  admitad_show_products_links         :boolean
#  admitad_site_url                    :string
#  admitad_status                      :string
#  admitad_traffics                    :jsonb
#  data                                :jsonb
#  gdeslon_affiliate_link              :string
#  gdeslon_categories                  :jsonb
#  gdeslon_conditions                  :string
#  gdeslon_country                     :string
#  gdeslon_description                 :text
#  gdeslon_gs_commission_mark          :string
#  gdeslon_is_green                    :boolean
#  gdeslon_kind                        :string
#  gdeslon_logo_file_name              :string
#  gdeslon_name                        :string
#  gdeslon_short_description           :text
#  gdeslon_tariffs                     :jsonb
#  gdeslon_traffic_types               :jsonb
#  gdeslon_url                         :string
#  is_active                           :boolean          default(TRUE), not null
#  name                                :string
#  synced_at                           :datetime
#  type                                :string
#  created_at                          :datetime         not null
#  updated_at                          :datetime         not null
#  admitad_id                          :integer
#  ext_id                              :string
#  gdeslon_id                          :integer
#
# Indexes
#
#  index_advertisers_on_type_and_ext_id  (type,ext_id) UNIQUE
#
class Advertisers::Admitad < Advertiser

  include Advertisers::AdmitadAttributesMapper

  def model_name
    self.class.superclass.model_name
  end

end
