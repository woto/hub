# frozen_string_literal: true

class MultipleTagsPreview < ViewComponent::Preview
  layout 'view_component'

  def with_two_tags
    render ReactComponent.new(name: 'MultipleTags',
                              class: '',
                              props: {
                                tags: [{ title: 'text 1' }, {title: 'text 2'}],
                                textColor: 'tw-text-blue-800',
                                bgColor: 'tw-bg-blue-100'
                              })
  end

  def with_fifty_tags
    render ReactComponent.new(name: 'MultipleTags',
                              class: '',
                              props: {
                                tags: 50.times.map { |i| { title: "#{Faker::Lorem.word} #{i}" }},
                                textColor: 'tw-text-blue-800',
                                bgColor: 'tw-bg-blue-100'
                              })
  end
end