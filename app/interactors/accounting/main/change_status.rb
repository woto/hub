# frozen_string_literal: true

module Accounting
  module Main
    class ChangeStatus
      include ApplicationInteractor

      contract do
        params do
          config.validate_keys = true
          required(:record)
        end

        rule(:record) do
          key.failure('must be instance of Check or Post') unless value.is_a?(Check) || value.is_a?(Post)
        end
      end

      before do
        status_context = StatusContext.new(record: context.record, from_status: from_status)
        policy = policy_class.new(Current.responsible, status_context)
        raise Pundit::NotAuthorizedError unless policy.public_send("to_#{context.record.status}?")
      end

      def call
        TransactionGroup.start(self.class) do |group|
          if from_id
            Accounting::CreateTransaction.call(
              credit: Account.for_user(from_user, from_status, from_currency),
              debit: Account.for_subject(:hub, from_status, from_currency),
              amount: from_amount,
              group: group,
              obj: context.record
            )
          end

          Accounting::CreateTransaction.call(
            credit: Account.for_subject(:hub, context.record.status, context.record.currency),
            debit: Account.for_user(context.record.user, context.record.status, context.record.currency),
            amount: context.record.amount,
            group: group,
            obj: context.record
          )
        end
      end

      private

      def policy_class
        case context.record
        when Post
          PostStatusPolicy
        when Check
          CheckStatusPolicy
        end
      end

      def from_status
        context.record.attribute_before_last_save(:status)
      end

      def from_currency
        context.record.attribute_before_last_save(:currency)
      end

      def from_amount
        context.record.attribute_before_last_save(:amount)
      end

      def from_id
        context.record.attribute_before_last_save(:id)
      end

      def from_user_id
        context.record.attribute_before_last_save(:user_id)
      end

      def from_user
        if context.record.user.id == from_user_id
          context.record.user
        else
          User.find(from_user_id)
        end
      end
    end
  end
end