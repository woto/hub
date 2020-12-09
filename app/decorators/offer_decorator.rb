class OfferDecorator < ApplicationDecorator
  def pictures
    object['_source']['picture'] || object['_source']['image']
  end
end
