# frozen_string_literal: true

class OffersBulk < Dry::Struct
  attribute :data, Offer
  attribute :_index, Types::String
  attribute :_id, Types::String
end
