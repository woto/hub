# frozen_string_literal: true

class Networks::Gdeslon::Sync
  include ApplicationInteractor

  def call
    url = "https://www.gdeslon.ru/api/users/shops.xml?api_token=#{ENV.fetch('GDESLON_TOKEN')}"
    doc = Nokogiri::XML(URI.open(url))
    doc.root.elements.each do |shop|
      advertiser = Advertisers::Gdeslon
                   .lock
                   .where(ext_id: shop.at_css('id').text)
                   .first_or_initialize
      shop.elements.each do |el|
        advertiser.public_send("_#{el.name.underscore}=", el)
      end
      advertiser.data = shop.to_s
      advertiser.synced_at = Time.current
      advertiser.save!
    end
  end
end
