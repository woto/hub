# frozen_string_literal: true

module Listings
  class MentionsInteractor
    include ApplicationInteractor

    def call
      # debugger
      entity_ids = Favorite.find(context.id).favorites_items.pluck(:ext_id)

      context.object = ::Mentions::IndexInteractor.call(
        params: context.params,
        current_user: context.current_user,
        request: context.request,
        entity_ids:
      ).object
    end
  end
end
