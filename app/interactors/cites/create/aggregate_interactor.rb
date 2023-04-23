# frozen_string_literal: true

module Cites
  module Create
    class AggregateInteractor
      include ApplicationInteractor
      delegate :entity, :mention, to: :context

      contract do
        params do
          required(:entity)
          required(:mention)
        end
      end

      def call
        select = <<~SQL.squish
          MODE() WITHIN GROUP (ORDER BY mention_date) AS mode_mention_date,
          MODE() WITHIN GROUP (ORDER BY relevance) AS mode_relevance,
          AVG(sentiment) as average_sentiment
        SQL

        data = Cite.select(select)
                   .where(entity:, mention:)
                   .group(:entity_id, :mention_id)[0]

        EntitiesMention.find_or_initialize_by(mention:, entity:)
                       .update!(
                         mention_date: data[:mode_mention_date],
                         relevance: data[:mode_relevance],
                         sentiment: data[:average_sentiment]
                       )
      end
    end
  end
end
