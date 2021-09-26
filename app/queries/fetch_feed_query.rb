# frozen_string_literal: true

class FetchFeedQuery
  include ApplicationInteractor

  def call
    ActiveRecord::Base.connection.execute("SET LOCAL lock_timeout = '5s'")

    scope = Feed.where(locked_by_tid: '')
                .order('priority DESC, processing_finished_at ASC NULLS FIRST')

    if context.feed
      scope = scope.where(id: context.feed.id)
    end

    context.object = scope.lock('FOR UPDATE')
  end
end
