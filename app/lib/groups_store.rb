# frozen_string_literal: true

class GroupsStore
  attr_reader :items

  def initialize
    @searched_items = []
    super
  end

  def append(id, foreign_key)
    @searched_items << { id: id, model: foreign_key.to_s.titleize.delete(' ').constantize }
  end

  def find(needle_id, needle_favorite_item_kind)
    execute_query
    model = needle_favorite_item_kind.to_s.titleize.delete(' ').constantize
    @execute_query.find { |obj| obj.id == needle_id.to_i && obj.instance_of?(model) } || raise('needle is not found')
  end

  def execute_query
    return @execute_query if defined?(@execute_query)

    @execute_query = []
    grouped_items = @searched_items.group_by { |item| item[:model] }
    grouped_items.each do |model, items|
      @execute_query += model.find(items.map { |itm| itm[:id] })
    end
  end
end
