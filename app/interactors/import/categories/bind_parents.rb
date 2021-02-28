# frozen_string_literal: true

module Import
  module Categories
    class BindParents
      include ApplicationInteractor

      class Contract < Dry::Validation::Contract
        params do
          config.validate_keys = true
          required(:feed).maybe(type?: Feed)
        end
      end

      before do
        result = Contract.new.call(context.to_h)
        raise result.inspect if result.failure?
      end

      class BindParentError < StandardError; end

      def call
        children_categories.find_each do |child|
          parent = context.feed.feed_categories.find_by(ext_id: child.ext_parent_id)

          raise BindParentError, 'Parent category was not found' unless parent
          raise BindParentError, 'Unable to update child category' unless child.update(parent: parent)
        rescue BindParentError => e
          Yabeda.hub.bind_parents_error.increment({ feed_id: context.feed.id, message: e.message }, by: 1)
          next
        end
      end

      private

      def children_categories(&block)
        FeedCategory.where.not(ext_parent_id: nil).where(feed: context.feed)
      end
    end
  end
end
