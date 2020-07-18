# frozen_string_literal: true

module Ext
  module Admitad
    module Api
      module Campaigns
        class GetJob
          include ApplicationInteractor

          def call
            Rails.logger.info('Ext::Admitad::Api::Campaigns:GeJob')

            ActiveRecord::Base.transaction do
              processing_finished_at = Feed.arel_table[:processing_finished_at]
              feed = Feed.lock.where(processing_started_at: nil)
                         .or(Feed.lock.where(locked_by_pid: 0).where(processing_finished_at.lt(5.hours.ago)))
                         .or(Feed.lock.where(processing_finished_at.lt(7.days.ago)))
                         .order(processing_finished_at: :asc)
                         .first
              if feed.present?
                feed.update!(locked_by_pid: Process.pid,
                             last_attempt_uuid: SecureRandom.uuid,
                             processing_started_at: Time.current)
                Rails.logger.info(feed)
              else
                Rails.logger.info('No suitable jobs were found')
                exit
              end

              # # "feeds_info.name": {"$regex": ".*just.*", '$options':'i'},
              # @doc = Ext::Admitad::Campaign.collection.find_one_and_update(
              #   { 'feeds_info': { '$elemMatch': { '$or': [
              #     # { "feed_name": {"$regex": ".*intimshop.*", '$options':'i'} },
              #     # { "error": { "$ne": None } },
              #     { processing: { '$exists': false } },
              #     { processing: false, processing_finished_at: { '$lt': 1.day.ago } },
              #     { processing: false, processing_finished_at: nil }
              #   ] } } },
              #   { '$set': {
              #     'feeds_info.$.uuid': context.uuid,
              #     'feeds_info.$.processing': true,
              #     'feeds_info.$.processing_started_at': Time.current,
              #     'feeds_info.$.processing_finished_at': nil
              #   } },
              #   'return_document': :after,
              #   'projection': { 'id': 1, 'name': 1, 'feeds_info': { '$elemMatch': { 'uuid': context.uuid } } }
              # )
              # # sort = [("feeds_info.$.processing_finished_at", pymongo.DESCENDING)]
              context.feed = feed
            end
          end
        end
      end
    end
  end
end
