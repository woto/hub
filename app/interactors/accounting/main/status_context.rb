module Accounting
  module Main
    class StatusContext
      attr_reader :record, :from_status

      def initialize(record:, from_status:)
        @record = record
        @from_status = from_status
      end
    end
  end
end
