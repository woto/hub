# frozen_string_literal: true

class TextTagComponent < ViewComponent::Base
  def initialize(text_tag:, text_color:, bg_color:, linkify: true)
    raise 'OBSOLETE'

    # super
    # @text_tag = text_tag
    # @linkify = linkify
    # @bg_color = bg_color
    # @text_color = text_color
  end

  def render?
    # @text_tag.present?
  end

  private

  def link_if_url(text_tag)
  #   return text_tag unless @linkify
  #
  #   URI.parse(text_tag).tap { |uri| raise 'wrong url' unless uri.host && %w[http https].include?(uri.scheme) }
  # rescue StandardError
  #   text_tag
  # else
  #   link_to @text_tag.gsub(/\A(https:\/\/|http:\/\/)/, '').gsub(/\Awww\./, '').gsub(/\/\z/, ''), @text_tag,
  #           class: 'tw-underline',
  #           rel: [Seo::NoReferrer, Seo::NoFollow, Seo::UGC]
  end
end
