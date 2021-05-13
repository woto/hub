# frozen_string_literal: true

class FavoriteDecorator < ApplicationDecorator
  def name
    h.link_to super, h.url_for({ controller: "/#{object['_source']['kind']}", favorite_id: object['_id'] })
  end
end
