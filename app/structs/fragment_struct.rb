# frozen_string_literal: true

require 'dry-struct'

module Types
  include Dry.Types()
end

class FragmentStruct < Dry::Struct
  transform_keys(&:to_sym)

  attribute :location_url, Types::String
  attribute :text_start, Types::String
  attribute :text_end, Types::String
  attribute :prefix, Types::String
  attribute :suffix, Types::String
end
