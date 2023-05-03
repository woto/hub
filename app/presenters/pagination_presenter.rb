# frozen_string_literal: true

class PaginationPresenter
  include ApplicationInteractor

  def call
    context.object =
      {
        current_page: context.collection.current_page,
        total_pages: context.collection.total_pages,
        limit_value: context.collection.limit_value,
        entry_name: context.collection.entry_name,
        total_count: context.collection.total_count,
        offset_value: context.collection.offset_value,
        last_page: context.collection.last_page?
      }
  end
end
