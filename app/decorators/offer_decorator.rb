class OfferDecorator < ApplicationDecorator
  def pictures
    object['_source']['picture'] || object['_source']['image']
  end

  def name
    names = object.dig('_source', 'name')
    names && names.map { |item| h.strip_tags(item[Import::Offers::Hashify::HASH_BANG_KEY]) }.join(', ')
  end
end
