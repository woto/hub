# frozen_string_literal: true

require 'dry-struct'

module Types
  include Dry.Types()
end

class OauthStruct < Dry::Struct
  transform_keys(&:to_sym)

  attribute :uid, Types::String
  attribute :provider, Types::String
  attribute :info, Types::Hash
  attribute :credentials, Types::Hash
  attribute :extra, Types::Hash
end
