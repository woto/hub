# frozen_string_literal: true

class BookmarkComponent < ViewComponent::Base
  def initialize(ext_id:, favorites_items_kind:, favorites_store:)
    @ext_id = ext_id
    @favorites_items_kind = favorites_items_kind
    @is_checked = favorites_store.find(ext_id, favorites_items_kind)
  end
end
