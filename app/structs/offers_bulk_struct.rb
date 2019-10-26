# frozen_string_literal: true

class OffersBulkStruct < Dry::Struct
  attribute :data, OfferStruct
  attribute :_index, Types::String
  attribute :_id, Types::String
end
