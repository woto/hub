# frozen_string_literal: true

class TextTagComponent < ViewComponent::Base
  def initialize(text_tag:, linkify: true)
    @text_tag = text_tag
    @linkify = linkify
  end

  def render?
    @text_tag.present?
  end

  private

  def link_if_url(text_tag)
    return text_tag unless @linkify

    URI.parse(text_tag).tap { |uri| raise 'wrong url' unless uri.host && %w[http https].include?(uri.scheme) }
  rescue StandardError
    text_tag
  else
    link_to @text_tag, @text_tag, class: 'text-white', rel: 'noreferrer'
  end
end
