# frozen_string_literal: true

module Entities
  class AliasComponent < ViewComponent::Base
    def initialize(alias:)
      @alias = binding.local_variable_get(:alias)
    end

    def render?
      @alias.present?
    end

    private

    def link_if_url(_alias)
      URI.parse(_alias).tap { |uri| raise 'wrong url' unless uri.host && %w[http https].include?(uri.scheme) }
    rescue StandardError
      _alias
    else
      link_to @alias, @alias, class: 'text-white', rel: 'noreferrer'
    end
  end
end
