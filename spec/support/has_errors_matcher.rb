module HasErrorsMatcher
  class HasErrors
    def initialize(expected)
      @expected = expected
    end

    def matches?(target)
      @target = target
      @target.valid?
      @target.errors.of_kind?(*@expected)
    end

    def failure_message
      "expected #{@target.inspect} to has error #{@expected}"
    end

    def failure_message_when_negated
      "expected #{@target.inspect} has no error #{@expected}"
    end
  end

  def has_errors(*expected)
    HasErrors.new(expected)
  end
end

RSpec::configure do |config|
  config.include(HasErrorsMatcher)
end
