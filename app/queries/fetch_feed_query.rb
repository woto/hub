# frozen_string_literal: true

class FetchFeedQuery
  include ApplicationInteractor

  def call
    scope = Feed.where(locked_by_pid: 0)
                .order('priority DESC, processing_finished_at ASC NULLS FIRST')

    if context.feed
      scope = scope.where(id: context.feed.id)
    end

    context.object = scope.lock('FOR UPDATE NOWAIT')
  end
end
