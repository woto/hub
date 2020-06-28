#

require 'dry-struct'

module Types
  include Dry.Types()
end

class OfferStruct < Dry::Struct
  attribute :name, Types::String
  attribute :price, Types::Float
  attribute :currencyId, Types::String
  attribute :url, Types::String
  attribute :picture, Types::Array
end
