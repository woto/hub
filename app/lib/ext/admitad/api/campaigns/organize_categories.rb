# frozen_string_literal: true

module Ext
  module Admitad
    module Api
      module Campaigns
        class OrganizeCategories
          include ApplicationInteractor

          def call
            Rails.logger.info('Ext::Admitad::Api::Campaigns::OrganizeCategories')

            FeedCategory.where(feed: context.feed).find_each do |child|
              if child.ext_parent_id
                parent = FeedCategory.find_by(feed: context.feed,
                                              ext_id: child.ext_parent_id)
                if parent && parent != child
                  child.update!(parent: parent,
                                parent_not_found: false,
                                last_attempt_uuid: context.feed.last_attempt_uuid)
                else
                  child.update!(parent_not_found: true,
                                last_attempt_uuid: context.feed.last_attempt_uuid)
                end
              end
            end
          end
        end
      end
    end
  end
end
