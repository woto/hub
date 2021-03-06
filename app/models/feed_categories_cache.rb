# frozen_string_literal: true

class FeedCategoriesCache
  attr_accessor :items

  Item = Struct.new(:id, :path_ids, :ext_id, :attempt_uuid, keyword_init: true)

  def initialize(feed)
    @feed = feed

    select = ['ext_id', 'id', "array_append(string_to_array(ancestry, '/'), id::text)::int[] as uptree_ids",
              'attempt_uuid']

    map =  lambda { |fc|
      { fc.ext_id => Item.new(id: fc.id, path_ids: fc.uptree_ids, ext_id: fc.ext_id, attempt_uuid: fc.attempt_uuid) }
    }

    @items = feed.feed_categories
                 .select(select)
                 .map(&map)
                 .reduce(&:merge) || {}
  end

  def find(ext_id:, attempt_uuid:)
    found = items[ext_id]
    found if found && found.attempt_uuid == attempt_uuid
  end

  def append_or_update(id:, ext_id:, path_ids:, attempt_uuid:)
    @items[ext_id] = Item.new(id: id, path_ids: path_ids, ext_id: ext_id, attempt_uuid: attempt_uuid)
  end

  def ==(other)
    items == other.items && @feed == other.instance_variable_get(:@feed)
  end
end
