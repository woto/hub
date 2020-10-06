# frozen_string_literal: true

module ApplicationHelper
  # def tree_item(parent, children)
  #   concat render('feed_category_checkbox', name: parent.name, style: "margin-left: #{parent.depth * 20}px")
  #   children.each { |k, v| tree_item(k, v) } && nil
  # end

  def method_missing(_name, *args)
    scalar = args.first
    if scalar.is_a?(String)
      truncate(scalar)
    elsif scalar.is_a?(Hash)
      truncate(scalar.to_s)
    elsif scalar.is_a?(Array)
      truncate(scalar.to_s)
    elsif scalar.is_a?(ActiveSupport::TimeWithZone)
      l(scalar, format: :short)
    else
      scalar
    end
  end
end
