# frozen_string_literal: true

module Filters
  class DateForm < BaseForm
    attr_accessor :min, :max

    validates :min, :max, presence: true
  end
end
