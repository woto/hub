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
#  data                                :text
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
class Advertisers::Gdeslon < Advertiser

  index_name "#{Rails.env}.advertisers"

  def _id=(val)
    self.gdeslon_id = val.text
  end

  def _name=(val)
    self.name = val.text
    self.gdeslon_name = val.text
  end

  def _short_description=(val)
    self.gdeslon_short_description = val.text
  end

  def _description=(val)
    self.gdeslon_description = val.text
  end

  def _url=(val)
    self.gdeslon_url = val.text
  end

  def _conditions=(val)
    self.gdeslon_conditions = val.text
  end

  def _is_green=(val)
    self.gdeslon_is_green = ActiveModel::Type::Boolean.new.cast(val.text)
  end

  def _gs_commission_mark=(val)
    self.gdeslon_gs_commission_mark = val.text
  end

  def _country=(val)
    self.gdeslon_country = val.text
  end

  def _kind=(val)
    self.gdeslon_kind = val.text
  end

  def _categories=(val)
    self.gdeslon_categories = val.elements.map do |category|
      category.elements.each_with_object({}) do |categorys_element, h|
        h[categorys_element.name] = categorys_element.text
      end
    end
  end

  def _logo_file_name=(val)
    self.gdeslon_logo_file_name = val.text
  end

  def _affiliate_link=(val)
    self.gdeslon_affiliate_link = val.text
  end

  def _traffic_types=(val)
    self.gdeslon_traffic_types = val.elements.map do |traffic_type|
      traffic_type.elements.each_with_object({}) do |traffic_types_element, h|
        h[traffic_types_element.name] = traffic_types_element.text
      end
    end
  end

  def _tariffs=(val)
    self.gdeslon_tariffs = val.elements.map do |el|
      GlobalHelper.hashify(el)
    end
  end

  # Other methods

  def model_name
    self.class.superclass.model_name
  end


end
