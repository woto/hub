# frozen_string_literal: true

class OfferDecorator < ApplicationDecorator
  def pictures
    (
      object['_source']['picture'] ||
        object['_source']['image'] ||
        # Triple forward slash is not error. By the way it is ironically that if image will not be found
        # in IMGPROXY_LOCAL_FILESYSTEM_ROOT it will fallback to the same image due to IMGPROXY_FALLBACK_IMAGE_PATH.
        # You could check local serving behaviour by commenting IMGPROXY_FALLBACK_IMAGE_PATH
        [{ Import::Offers::Hashify::HASH_BANG_KEY => 'local:///image-not-found.png' }]
    )&.slice(0, 10)
  end

  def name
    names = object.dig('_source', 'name')
    names = names&.map { |item| h.strip_tags(item[Import::Offers::Hashify::HASH_BANG_KEY]) }&.join(', ')
    h.truncate(names.to_s, length: 100)
  end

  def url
    super.first[Import::Offers::Hashify::HASH_BANG_KEY]
  end
end
