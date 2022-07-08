# frozen_string_literal: true

require 'dry-struct'

module Types
  include Dry.Types()
end

module Fragment
  class Struct < Dry::Struct
    transform_keys(&:to_sym)

    attribute :url, Types::String
    attribute :texts, Types::Array.of(Fragment::Text)
  end
end
