# frozen_string_literal: true

class Embed
  include ActiveModel::Model
  include ActiveModel::Attributes
  include GlobalID::Identification
  include ActionText::Attachable

  attribute :offer_url
  attribute :embed_type

  def id
    offer_url + embed_type
  end

  def self.find(id)
    new(id: id)
  end

  def to_trix_content_attachment_partial_path
    'offers/embeds/preview'
  end
end
