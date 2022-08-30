# frozen_string_literal: true

class SingleTagPreview < ViewComponent::Preview
  layout 'view_component'

  def with_text
    render ReactComponent.new(name: 'SingleTag',
                              class: '',
                              props: {
                                tag: { title: 'text' },
                                textColor: 'tw-text-blue-800',
                                bgColor: 'tw-bg-blue-100'
                              })
  end

  def with_long_text
    render ReactComponent.new(name: 'SingleTag',
                              class: '',
                              props: {
                                tag: { title: 'this tag contain very long text and may be it is longest in the world' },
                                textColor: 'tw-text-blue-800',
                                bgColor: 'tw-bg-blue-100'
                              })
  end

  def with_different_colors
    render ReactComponent.new(name: 'SingleTag',
                              class: '',
                              props: {
                                tag: { title: 'pink tag' },
                                textColor: 'tw-text-pink-800',
                                bgColor: 'tw-bg-pink-100'
                              })
  end

  def with_linkify_text
    render ReactComponent.new(name: 'SingleTag',
                              class: '',
                              props: {
                                tag: { title: 'does not break with linkify: true' },
                                textColor: 'tw-text-blue-800',
                                bgColor: 'tw-bg-blue-100',
                                linkify: true
                              })
  end

  def with_linkify_url
    render ReactComponent.new(name: 'SingleTag',
                              class: '',
                              props: {
                                tag: { title: 'https://www.truncates-to-domain.ru/foo' },
                                textColor: 'tw-text-blue-800',
                                bgColor: 'tw-bg-blue-100',
                                linkify: true
                              })
  end

  def with_custom_url
    render ReactComponent.new(name: 'SingleTag',
                              class: '',
                              props: {
                                tag: { title: 'leads to example.com/foo', url: 'http://example.com/foo' },
                                textColor: 'tw-text-blue-800',
                                bgColor: 'tw-bg-blue-100',
                              })
  end
end
