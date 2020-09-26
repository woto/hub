module Advertisers::AdmitadAttributesMapper
  extend ActiveSupport::Concern

  included do

    def _id=(val)
      self.admitad_id = val
    end

    def _name=(val)
      self.name = val
      self.admitad_name = val
    end

    def _site_url=(val)
      self.admitad_site_url = val
    end

    def _description=(val)
      self.admitad_description = val
    end

    def _raw_description=(val)
      self.admitad_raw_description = val
    end

    def _currency=(val)
      self.admitad_currency = val
    end

    def _rating=(val)
      self.admitad_rating = val
    end

    def _ecpc=(val)
      self.admitad_ecpc = val
    end

    def _epc=(val)
      self.admitad_epc = val
    end

    def _cr=(val)
      self.admitad_cr = val
    end

    def _actions=(val)
      self.admitad_actions = val
    end

    def _regions=(val)
      self.admitad_regions = val
    end

    def _categories=(val)
      self.admitad_categories = val
    end

    def _status=(val)
      self.admitad_status = val
    end

    def _image=(val)
      self.admitad_image = val
    end

    def _ecpc_trend=(val)
      self.admitad_ecpc_trend = val
    end

    def _epc_trend=(val)
      self.admitad_epc_trend = val
    end

    def _cr_trend=(val)
      self.admitad_cr_trend = val
    end

    def _exclusive=(val)
      self.admitad_exclusive = val
    end

    def _activation_date=(val)
      self.admitad_activation_date = Time.zone.parse(val)
    end

    def _modified_date=(val)
      self.admitad_modified_date = Time.zone.parse(val)
    end

    def _denynewwms=(val)
      self.admitad_denynewwms = val
    end

    def _goto_cookie_lifetime=(val)
      self.admitad_goto_cookie_lifetime = val
    end

    def _retag=(val)
      self.admitad_retag = val
    end

    def _show_products_links=(val)
      self.admitad_show_products_links = val
    end

    def _landing_code=(val)
      self.admitad_landing_code = val
    end

    def _landing_title=(val)
      self.admitad_landing_title = val
    end

    def _geotargeting=(val)
      self.admitad_geotargeting = val
    end

    def _max_hold_time=(val)
      self.admitad_max_hold_time = val
    end

    def _traffics=(val)
      self.admitad_traffics = val
    end

    def _avg_hold_time=(val)
      self.admitad_avg_hold_time = val
    end

    def _avg_money_transfer_time=(val)
      self.admitad_avg_money_transfer_time = val
    end

    def _allow_deeplink=(val)
      self.admitad_allow_deeplink = val
    end

    def _coupon_iframe_denied=(val)
      self.admitad_coupon_iframe_denied = val
    end

    def _action_testing_limit=(val)
      self.admitad_action_testing_limit = val
    end

    def _mobile_device_type=(val)
      self.admitad_mobile_device_type = val
    end

    def _mobile_os=(val)
      self.admitad_mobile_os = val
    end

    def _mobile_os_type=(val)
      self.admitad_mobile_os_type = val
    end

    def _action_countries=(val)
      self.admitad_action_countries = val
    end

    def _allow_actions_all_countries=(val)
      self.admitad_allow_actions_all_countries = val
    end

    def _connection_status=(val)
      self.admitad_connection_status = val
    end

    def _gotolink=(val)
      self.admitad_gotolink = val
    end

    def _products_xml_link=(val)
      self.admitad_products_xml_link = val
    end

    def _products_csv_link=(val)
      self.admitad_products_csv_link = val
    end

    def _moderation=(val)
      self.admitad_moderation = val
    end

    def _feeds_info=(val)
      self.admitad_feeds_info = val
    end

    def _actions_detail=(val)
      self.admitad_actions_detail = val
    end

    def _actions_limit=(val)
      self.admitad_actions_limit = val
    end

    def _actions_limit_24=(val)
      self.admitad_actions_limit_24 = val
    end
  end
end
