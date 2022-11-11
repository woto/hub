# frozen_string_literal: true

require 'dry-struct'

module Types
  include Dry.Types()
end

module Entities
  class Operation < Dry::Struct
    transform_keys(&:to_sym)

    # attribute :field, Types::Symbol.enum(:title, :images, :intro, :topics, :lookups)
    attribute? :add, Types::Nominal::Any
    attribute? :remove, Types::Nominal::Any
  end

  class TimelineStruct < Dry::Struct
    transform_keys(&:to_sym)

    attribute :id, Types::Integer

    # cite attributes
    attribute? :relevance, Types::Integer.optional
    attribute? :sentiment, Types::Integer.optional
    attribute? :mention_date, Types::DateTime.optional
    attribute :created_at, Types::Time

    # link
    # attribute? :link_url, Types::String.optional
    attribute :link_url, Types::String.optional

    # mention
    attribute :mention_title, Types::String.optional
    attribute :mention_url, Types::String.optional

    attribute :target_url, Types::String.optional

    # fragment
    attribute :prefix, Types::String.optional
    attribute :suffix, Types::String.optional
    attribute :text_start, Types::String.optional
    attribute :text_end, Types::String.optional

    # user attributes
    attribute :user_name, Types::String
    attribute :user_path, Types::String
    # https://dry-rb.org/gems/dry-schema/1.9/advanced/composing-schemas/
    # string or variant (which also should be replaced with shrine)
    attribute :user_image, Types::Strict::Any

    # entity attributes
    attribute? :title, Operation
    attribute? :intro, Operation

    # relations
    attribute? :images, Operation.optional
    attribute? :topics, Operation.optional
    attribute? :lookups, Operation.optional
  end
end
