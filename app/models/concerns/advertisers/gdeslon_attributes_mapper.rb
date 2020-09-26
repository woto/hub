module Advertisers::GdeslonAttributesMapper
  extend ActiveSupport::Concern

  included do
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
  end
end
