# frozen_string_literal: true

module ApplicationHelper
  def tree_item(parent, children)
    concat content_tag :div, parent.name, style: "margin-left: #{parent.depth * 30}px"
    children.each { |k, v| tree_item(k, v) } && nil
  end
end
