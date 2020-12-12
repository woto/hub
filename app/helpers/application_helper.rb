# frozen_string_literal: true

module ApplicationHelper
  def conditional_tag(name, condition, options = nil, &block)
    if condition
      content_tag name, capture(&block), options
    else
      capture(&block)
    end
  end

  def favorites_dropdown_items
    @favorites_dropdown_items ||= begin
         client = Elasticsearch::Client.new Rails.application.config.elastic
         client.search(FavoritesSearchQuery.call(sort: 'name.keyword', order: 'asc', from: 0, size: 40).object)
               .dig('hits', 'hits')
               .map { _1['_source'] }
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
