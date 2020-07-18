# frozen_string_literal: true

module Ext
  module Admitad
    module Api
      module Campaigns
        class ReleaseJob
          include ApplicationInteractor

          def call
            Rails.logger.info('Ext::Admitad::Api::Campaigns::ReleaseJob')

            unless context.feed
              Rails.logger.info('There are no feeds to release')
              return
            end

            result = context.feed.update(
              locked_by_pid: 0,
              processing_finished_at: Time.current,
              last_error: context.error
            )

            if result
              Rails.logger.info(context.feed)
              Rails.logger.info('Job released')
            else
              Rails.logger.info('Unable to release job')
            end

            # doc = Ext::Admitad::Campaign.collection.find_one_and_update(
            #   { "feeds_info": { "$elemMatch": { "uuid": context.uuid } } },
            #   { "$set": {
            #     # TODO: need this?
            #     # "feeds_info.$.feed_name": feed_name,
            #     "feeds_info.$.processing": false,
            #     "feeds_info.$.processing_finished_at": Time.current,
            #     "feeds_info.$.error": context.error
            #   } },
            #   return_document: :after,
            #   projection: { "id": 1, "name": 1, "feeds_info": { "$elemMatch": { "uuid": context.uuid } } }
            # )
          end
        end
      end
    end
  end
end
