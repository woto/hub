# frozen_string_literal: true

module Interactors
  module EntitiesMentions
    class FindByUrlAndEntity
      include ApplicationInteractor
      delegate :cite, :entity, :user, :params, to: :context

      def call
        entities_mention = EntitiesMention.joins(:mention).where(mentions: { url: context.params[:url] })
        entities_mention = entities_mention.where(entity_id: params[:entity_id]) if params[:entity_id]
        entities_mention = entities_mention.first
        fail!(message: 'EntitiesMention not found', code: 404) unless entities_mention

        context.object = { mention_date: entities_mention.mention_date }
      end
    end
  end
end
