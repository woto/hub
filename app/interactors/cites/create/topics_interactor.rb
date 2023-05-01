# frozen_string_literal: true

module Cites
  module Create
    class TopicsInteractor
      include ApplicationInteractor
      delegate :params, to: :context

      contract do
        params do
          required(:cite)
          required(:entity)
          required(:user)
          required(:params).maybe do
            array(:hash) do
              required(:id)
              required(:destroy)
              required(:title)
            end
          end
        end
      end

      def call
        return if params.nil?

        without_ids, with_ids = params.partition { |topic_params| topic_params[:id].blank? }

        without_ids.each do |topic_params|
          topic = Topic.create_with(user: context.user).find_or_create_by!(title: topic_params[:title])
          TopicsRelation.create!(user: context.user, topic:, relation: context.cite)
          TopicsRelation.create!(user: context.user, topic:, relation: context.entity)
          Elasticsearch::IndexJob.perform_later(topic)
        end

        topics = Topic.find(with_ids.map { |item| item[:id] })

        with_ids.each do |topic_params|
          matched_topic = topics.find { |item| item.id == topic_params[:id] }

          if topic_params[:destroy]
            topics_relation = TopicsRelation.find_by(topic: matched_topic, relation: context.entity)
            topics_relation&.destroy!
          else
            TopicsRelation.create!(user: context.user, topic: matched_topic, relation: context.cite)
            TopicsRelation.create(user: context.user, topic: matched_topic, relation: context.entity)
          end
          Elasticsearch::IndexJob.perform_later(matched_topic)
        end
      end
    end
  end
end
