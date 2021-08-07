# frozen_string_literal: true

module Filters
  class TextForm < BaseForm
    attr_accessor :value

    validates :value, presence: true
  end
end
