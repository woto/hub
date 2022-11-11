# frozen_string_literal: true

module Interactors
  module Topics
    class Postgresql
      include ApplicationInteractor

      contract do
        params do
          config.validate_keys = true
          required(:q).maybe(:string)
        end
      end

      def call
        # NOTE: Can't recall SQL lol. Is there a better way to get this data?!
        topics = Topic.select('MAX(topics.id) AS id, MAX(topics.title) AS title, MAX(topics.topics_relations_count) AS topics_relations_count')
                      .joins('JOIN topics_relations ON topics_relations.topic_id = topics.id')
                      .order('MAX(topics_relations.created_at) DESC')
                      .group('topics_relations.topic_id')
                      .limit(5)

        context.object = topics.map do |topic|
          {
            id: topic.id,
            title: topic.title,
            count: topic.topics_relations_count
          }
        end
      end
    end
  end
end
