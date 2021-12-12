# frozen_string_literal: true

require 'dry-struct'

module Types
  include Dry.Types()
end

class IndexStruct < Dry::Struct
  transform_keys(&:to_sym)

  attribute :name, Types::String
  attribute :scoped, Types::String
end
