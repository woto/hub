# frozen_string_literal: true

class MoveMentionTagsToTopics < ActiveRecord::Migration[6.1]
  def change
    # reversible do |dir|
    #   dir.up do
    #     Mention.find_each do |mention|
    #       topics = []
    #       mention.tags.each do |tag|
    #         next if tag == ''
    #
    #         topics << Topic.find_or_create_by!(title: tag)
    #       end
    #       mention.update!(topics: topics)
    #     end
    #   end
    # end
  end
end
