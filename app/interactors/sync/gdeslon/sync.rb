# frozen_string_literal: true

module Sync
  module Gdeslon
    class Sync
      include ApplicationInteractor

      def call
        url = "https://www.gdeslon.ru/api/users/shops.xml?api_token=#{ENV.fetch('GDESLON_TOKEN')}"
        doc = Nokogiri::XML(URI.open(url))
        doc.root.elements.each do |shop|
          advertiser = Advertiser
                       .lock
                       .where(network: 'gdeslon', ext_id: shop.at_css('id').text)
                       .first_or_initialize
          shop.elements.each do |el|
            method_name = el.name.underscore
            if Advertisers::GdeslonAttributesMapper.respond_to?(method_name)
              Advertisers::GdeslonAttributesMapper.public_send(method_name, advertiser, el)
            end
          end
          advertiser.raw = shop.to_s
          advertiser.synced_at = Time.current
          advertiser.save!
        end
      end
    end
  end
end
