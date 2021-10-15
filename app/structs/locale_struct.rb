# frozen_string_literal: true

require 'dry-struct'

module Types
  include Dry.Types()
end

class LocaleStruct < Dry::Struct
  transform_keys(&:to_sym)

  attribute :title, Types::String
  attribute :locale, Types::String
  attribute :count, Types::Integer
end
