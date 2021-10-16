# frozen_string_literal: true

module Indexable
  extend ActiveSupport::Concern

  included do
    private

    def noindex
      condition = true
      condition = yield.present? if block_given?
      response.headers['X-Robots-Tag'] = 'noindex' if condition
    end
  end
end
