# frozen_string_literal: true

module Accounting
  module Posts
    class TransitToPending
      include ApplicationInteractor

      contract do
        params do
          config.validate_keys = true
          required(:post).value(type?: Post)
        end
      end

      before do
        unless Accounting::Posts::StatusPolicy.new(Current.responsible, context.post).to_pending?
          raise Pundit::NotAuthorizedError,
                "User with role `#{Current.responsible.role}` not allowed to Post#to_pending?"
        end
      end

      before do
        # TODO
        # case context.post.status_before_last_save
        # when nil, 'draft', 'pending', 'rejected'
        #   nil
        # else
        #   raise "wrong status transaction state: `#{context.post.status_previous_change}`"
        # end
      end

      def call
        TransactionGroup.start(self.class) do |group|
          if context.post.attribute_before_last_save(:id)
            Accounting::Actions::Post.call(
              from: Account.for_user(
                context.post.user,
                context.post.attribute_before_last_save(:status),
                context.post.attribute_before_last_save(:currency)
              ),
              to: Account.for_subject(
                :hub,
                context.post.attribute_before_last_save(:status),
                context.post.attribute_before_last_save(:currency)
              ),
              amount: context.post.attribute_before_last_save(:price),
              group: group,
              obj: context.post
            )
          end

          Accounting::Actions::Post.call(
            from: Account.for_subject(
              :hub,
              :pending,
              context.post.currency
            ),
            to: Account.for_user(
              context.post.user,
              :pending,
              context.post.currency
            ),
            amount: context.post.price,
            group: group,
            obj: context.post
          )
        end
      end
    end
  end
end
