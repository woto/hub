# frozen_string_literal: true

module Hostnameable
  extend ActiveSupport::Concern

  included do
    belongs_to :hostname, optional: true #, counter_cache: true
    before_validation :fill_hostname

    private

    def fill_hostname
      value = send(self.class.attribute_name)
      return if value.blank?

      title = begin
        URI.parse(value).hostname
      rescue StandardError
        nil
      end

      self.hostname = Hostname.find_or_create_by(title: title)
    end
  end

  class_methods do
    attr_accessor :attribute_name

    def hostnameable(attribute_name:)
      @attribute_name = attribute_name
    end
  end
end
