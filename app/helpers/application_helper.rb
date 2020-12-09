# frozen_string_literal: true

module ApplicationHelper

  def conditional_tag(name, condition, options=nil, &block)
    if condition
      content_tag name, capture(&block), options
    else
      capture(&block)
    end
  end

  # def tree_item(parent, children)
  #   concat render('feed_category_checkbox', name: parent.name, style: "margin-left: #{parent.depth * 20}px")
  #   children.each { |k, v| tree_item(k, v) } && nil
  # end

  # def method_missing(_name, *args)
  #   scalar = args.first
  #   if scalar.is_a?(String)
  #     truncate(scalar)
  #   elsif scalar.is_a?(Hash)
  #     truncate(scalar.to_s)
  #   elsif scalar.is_a?(Array)
  #     truncate(scalar.to_s)
  #   elsif scalar.is_a?(ActiveSupport::TimeWithZone)
  #     l(scalar, format: :short)
  #   else
  #     scalar
  #   end
  # end
end
