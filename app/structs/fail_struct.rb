# frozen_string_literal: true

require 'dry-struct'

module Types
  include Dry.Types()
end

class FailStruct < Dry::Struct
  transform_keys(&:to_sym)

  attribute :code, Types::Integer
  attribute :message, Types::String
end
