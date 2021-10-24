# frozen_string_literal: true

class OfferDecorator < ApplicationDecorator
  def pictures
    # Triple forward slash is not error. By the way it is ironically that if image will not be found
    # in IMGPROXY_LOCAL_FILESYSTEM_ROOT it will fallback to the same image due to IMGPROXY_FALLBACK_IMAGE_PATH.
    # You could check local serving behaviour by commenting IMGPROXY_FALLBACK_IMAGE_PATH

    images = (object['_source']['picture'] || []).yield_self do |objects|
      objects.pluck(Import::Offers::Hashify::HASH_BANG_KEY).slice(0, 10)
    end

    (images.presence || ['local:///image-not-found.png']).map do |url|
      format(ENV.fetch('IMGPROXY_URL'), url)
    end
  end

  def name
    (super.presence || [])
      .pluck(Import::Offers::Hashify::HASH_BANG_KEY)
      .join(', ')
      .yield_self { |names| h.truncate(names.to_s, length: 100) }
  end

  def url
    super.first[Import::Offers::Hashify::HASH_BANG_KEY]
  end
end
